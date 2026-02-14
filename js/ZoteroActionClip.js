// THIS SCRIPT DOESN'T WORK. HOW DO I PASTE FROM CLIPBOARD TO THIS PROGRAM?

/**
 * A description of this script.
 * @author edoolittle@firstnationsuniversity.ca
 * @usage Automatically put your annotation in Zotero into emacs org-roam file
 * @link https://github.com/windingwind/zotero-actions-tags/discussions/
 * @see https://github.com/windingwind/zotero-actions-tags/discussions/
 */

// This script is a combination of two other scripts. Some issues
// still need to be resolved.

// Load this script into Actions & Tags extension to Zotero

// Captures an annotation and submits it to org-protocol.
// Capture includes the annotated text, citation key, page number (approximate)
// and (hopefully) any (typed text?) comment that was made on the annotation

// Not sure if I'm using the correct citation key

// EDIT THESE SETTINGS

/** @type {string} Name of the field to use as the link text. To use the citation key, set this to "citationKey". */
let linkTextField = "title";

/** @type {'html' | 'md' | 'plain'} What type of link to create. */
let linkType = "plain";

/** @type {boolean} If true, make the link specific to the currently selected collection. */
let useColl = false;

/** @type {boolean} If true, use Better Notes zotero://note link when the selected item is a note. */
let useNoteLink = false;

/** @type {'select' | 'open-pdf' | 'auto'} Action of link*/
let linkAction = "auto"; // auto = open-pdf for PDFs and annotations, select for everything else

// END OF EDITABLE SETTINGS

// For efficiency, only execute once for all selected items
if (item) return;
item = items[0];
if (!item && !collection) return "[Copy Zotero Link] item is empty";

if (collection) {
  linkAction = "select";
  useColl = true;
}

if (linkAction === "auto") {
  if (item.isPDFAttachment() || item.isAnnotation()) {
    linkAction = "open-pdf";
  } else {
    linkAction = "select";
  }
}

const uriParts = [];
let uriParams = "";

let targetItem = item;
if (linkAction === "open-pdf") {
  uriParts.push("zotero://open-pdf");
  if (item.isRegularItem()) {
    targetItem = (await item.getBestAttachments()).find((att) =>
      att.isPDFAttachment()
    );
  } else if (item.isAnnotation()) {
    targetItem = item.parentItem;
    // If the item is an annotation, we want to open the PDF at the page of the annotation
    let pageIndex = 1;
    try {
      pageIndex = JSON.parse(item.annotationPosition).pageIndex + 1;
    } catch (e) {
      Zotero.warn(e);
    }
    uriParams = `?page=${pageIndex}&annotation=${item.key}`;
  }
} else {
  uriParts.push("zotero://select");
  if (item?.isAnnotation()) {
    targetItem = item.parentItem;
  }
}

if (!targetItem && !collection) return "[Copy Zotero Link] item is invalid";

// Get the link text using the `link_text_field` argument
let linkText;
if (collection) {
  // When `collection` is set, this script was triggered in the collection menu.
  // Use collection name if this is a collection link
  linkText = collection.name;
} else if (item.isAttachment()) {
  // Try to use top-level item for link text
  linkText = Zotero.Items.getTopLevel([item])[0].getField(linkTextField);
} else if (item.isAnnotation()) {
  // Add the annotation text to the link text
  linkText = `${targetItem.getField(linkTextField)}(${
    item.annotationComment || item.annotationText || "annotation"
  })`;
} else {
  // Use the item's field
  linkText = item.getField(linkTextField);
}

// Add the library or group URI part (collection must go first)
let libraryType = (collection || item).library.libraryType;
if (libraryType === "user") {
  uriParts.push("library");
} else {
  uriParts.push(
    `groups/${Zotero.Libraries.get((collection || item).libraryID).groupID}`
  );
}

// If useColl, make the link collection specific
if (useColl) {
  // see https://forums.zotero.org/discussion/73893/zotero-select-for-collections
  let coll = collection || Zotero.getActiveZoteroPane().getSelectedCollection();

  // It's possible that a collection isn't selected. When that's the case,
  // this will fall back to the typical library behavior.

  // If a collection is selected, add the collections URI part
  if (!!coll) uriParts.push(`collections/${coll.key}`);
}

if (!collection) {
  // Add the item URI part
  uriParts.push(`items/${targetItem.key}`);
}

// Join the parts together
let uri = uriParts.join("/");

// Add the URI parameters
if (uriParams) {
  uri += uriParams;
}

if (useNoteLink && item?.isNote() && Zotero.BetterNotes) {
  uri = Zotero.BetterNotes.api.convert.note2link(item);
}

// TODO: not sure that we need to add the link to the clipboard for this
// application, but let's keep doing it for now.

/* Don't mess with the clipboard as we are using its contents below
// Format the link and copy it to the clipboard
const clipboard = new Zotero.ActionsTags.api.utils.ClipboardHelper();
if (linkType == "html") {
  clipboard.addText(`<a href="${uri}">${linkText}</a>`, "text/unicode");
} else if (linkType == "md") {
  clipboard.addText(`[${linkText}](${uri})`, "text/unicode");
} else {
  clipboard.addText(uri, "text/unicode");
  }
*/

// Now we begin with Emacs for Org-Roam script, with a few modifications

if (!item) return; // Exit if no item is provided.

if (!item.isAnnotation()) return "[Action: Send to org-roam] Not an annotation item.";
// If the item is not an annotation, return a message.

return await sendAnnotationToOrgRoam(item);
// Asynchronously call the function to send the annotation to org-roam.

async function sendAnnotationToOrgRoam(annotationItem) {
  // We don't care if there's not text in the annotation
  // if (!annotationItem.annotationText) return "[Action: Send to org-roam] No text found in this annotation.";
  // If there is no text in the annotation, return a message.

    const Zotero = require("Zotero");
    const Zotero_Tabs = require("Zotero_Tabs");
    const itemID = Zotero_Tabs._tabs[Zotero_Tabs.selectedIndex].data.itemID;
    // Get the ID of the currently selected item.

    const articleItem = Zotero.Items.get(itemID);
    const clipboard = new Zotero.ActionsTags.api.utils.ClipboardHelper();

    const annotationText = annotationItem.annotationText + " ["
          + annotationItem.parentItem.parentItem.getField('citationKey')
          + ", p." + annotationItem.annotationPageLabel
          + " (check)]\nAnnotation Comment: "
          + annotationItem.annotationComment
          + "\nClipboard Contents: " + clipboard.getText()
  const documentTitle = articleItem.getField("title") || "Untitled Document";
  // Get the title of the article; if no title is available, set it to
  // "Untitled Document".

  const formattedAnnotation = formatForOrgRoam(documentTitle, annotationText);
  // Format the annotation content for org-roam.

  const result = await pushToOrgRoam(formattedAnnotation, documentTitle);
  // Push the formatted annotation to org-roam.

  return result.message;
  // Return the result message.
}

function formatForOrgRoam(title, text) {
  const timestamp = new Date().toISOString();
  // Get the current timestamp.

  return `
  ${text}
  `;
  //return `
  //* Annotation for ${title}
  //- Annotation: ${text}
  //- Created on: ${timestamp}
  //`;
  // Format and return the annotation content.
}

async function pushToOrgRoam(formattedAnnotation, title) {
  // Construct org-protocol URL.
  const orgProtocolUrl = `org-protocol://roam-ref?template=r&ref=${encodeURIComponent(uri)}&title=${encodeURIComponent(title)}&body=${encodeURIComponent(formattedAnnotation)}`;

    /*
    // This always generates an error message, perhaps because of the box that is popped
    // asking for permission every time.
  try {
    // Simulate a GET request to trigger the system handler (configured via xdg-mime).
    const response = await Zotero.HTTP.request("GET", orgProtocolUrl);

    // If successfully triggered.
    if (response && response.status && response.status === 200) {
      return {
        success: true,
        message: `Annotation sent successfully to org-roam with title: ${title}`,
        // Message indicating the annotation was successfully sent to org-roam with the given title.
      };
    } else {
      return {
        success: false,
        message: `Failed to trigger org-protocol. Response status: ${response.status}`,
        // Message indicating failure to trigger org-protocol, with the response status.
      };
    }
  } catch (error) {
    // Error handling.
    return {
      success: false,
	  message: "Response is not correct, but don't worry, emacs has probably got the annotation !"
      //message: `Error triggering org-protocol: ${error.message}`,
      // Message indicating an error occurred while triggering org-protocol, including the error message.
    };
  }
    */

    const response = await Zotero.HTTP.request("GET", orgProtocolUrl);
}


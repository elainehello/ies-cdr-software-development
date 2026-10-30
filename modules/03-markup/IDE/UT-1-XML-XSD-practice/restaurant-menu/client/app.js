const form = document.getElementById("menuForm");
const xmlOutput = document.getElementById("xmlOutput");
const serverResponse = document.getElementById("serverResponse");

function createXmlElement(document, parent, tagName, text) {
    const element = document.createElement(tagName);
    element.textContent = text;
    parent.appendChild(element);
}

function generateMenuXml() {
    const xmlDocument = document.implementation.createDocument(
        "",
        "menu",
        null
    );

    const root = xmlDocument.documentElement;

    const principal = document.getElementById("principal");
    const accompaniment = document.getElementById("acompanamiento");
    const dessert = document.getElementById("postre");

    const principalContainer = xmlDocument.createElement("principal");
    createXmlElement(
        xmlDocument,
        principalContainer,
        principal.value,
        principal.selectedOptions[0].text
    );
    root.appendChild(principalContainer);

    const accompanimentContainer =
        xmlDocument.createElement("acompanamiento");

    createXmlElement(
        xmlDocument,
        accompanimentContainer,
        accompaniment.value,
        accompaniment.selectedOptions[0].text
    );
    root.appendChild(accompanimentContainer);

    const dessertContainer = xmlDocument.createElement("postre");

    createXmlElement(
        xmlDocument,
        dessertContainer,
        dessert.value,
        dessert.selectedOptions[0].text
    );
    root.appendChild(dessertContainer);

    return new XMLSerializer().serializeToString(xmlDocument);
}

form.addEventListener("submit", async function (event) {
    event.preventDefault();

    const xml = generateMenuXml();
    xmlOutput.textContent = xml;
    serverResponse.textContent = "Sending menu...";

    try {
        const response = await fetch("http://localhost:8080/api/menu", {
            method: "POST",
            headers: {
                "Content-Type": "application/xml"
            },
            body: xml
        });

        const result = await response.text();

        serverResponse.textContent =
            `HTTP ${response.status}: ${result}`;

    } catch (error) {
        serverResponse.textContent =
            "Could not connect to the server. Is it running on port 8080?";

        console.error(error);
    }
});
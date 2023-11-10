

document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('new-case-form').addEventListener('submit', submitNewCase);
    document.getElementById('open-new-case').addEventListener('click', openNewCaseSection);
    document.getElementById('view-old-records').addEventListener('click', viewOldRecordsSection);
    document.getElementById('close-mdt').addEventListener('click', closeMDT);
    document.getElementById('surname').addEventListener('input', handleAutocomplete);
    document.getElementById('first-name').addEventListener('input', handleAutocomplete);

});

window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === 'openMDT') {
        showMDT();
    } else if (data.type === 'closeMDT') {
        hideMDT();
    }
});


// Function to handle new case submission
function submitNewCase(event) {
    event.preventDefault(); 

    let formData = new FormData(event.target);
    let caseData = {};
    formData.forEach((value, key) => { caseData[key] = value; });

    fetch(`https://${GetParentResourceName()}/fists-mdt:submitCase`, {
        method: 'POST',
        body: JSON.stringify(caseData),
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
    }).then(response => response.json()).then(data => {
        if (data && data.success) {
            console.log('Case submitted successfully');
        }
    }).catch(error => console.error('Error submitting case:', error));
}


function openNewCaseSection() {
    document.getElementById('new-case-form-section').style.display = 'block';
    document.getElementById('old-records-section').style.display = 'none';
}


function viewOldRecordsSection() {
    document.getElementById('new-case-form-section').style.display = 'none';
    document.getElementById('old-records-section').style.display = 'block';

}


function closeMDT() {
    fetch(`https://${GetParentResourceName()}/fists-mdt:close`, { method: 'POST' })
    .then(() => {

    }).catch(error => console.error('Error closing MDT:', error));
}


function handleAutocomplete(event) {
    const inputField = event.target;
    const inputType = inputField.id; 
    const partialName = inputField.value;

    if (partialName.length >= 2) { // Trigger autocomplete with at least 2 characters
        fetch(`https://${GetParentResourceName()}/fists-mdt:autocompleteName`, {
            method: 'POST',
            body: JSON.stringify({ partialName: partialName, inputType: inputType }),
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
        }).then(response => response.json()).then(data => {
            updateAutocompleteSuggestions(data, inputType);
        }).catch(error => console.error('Error in autocomplete:', error));
    }
}

// Function to update the autocomplete suggestions
function updateAutocompleteSuggestions(data, inputType) {
    let dataListId;
    if (inputType === 'surname') {
        dataListId = 'surname-suggestions';
    } else if (inputType === 'first-name') {
        dataListId = 'firstname-suggestions';
    } else {
        return; // In case of unexpected inputType
    }

    const dataList = document.getElementById(dataListId);
    dataList.innerHTML = ''; // Clear current suggestions

    data.forEach(item => {
        const option = document.createElement('option');
        option.value = (inputType === 'surname') ? item.lastname : item.firstname;
        dataList.appendChild(option);
    });
}

function showMDT() {
    document.getElementById('mdt-container').style.display = 'block';
}

// Function to hide the MDT interface
function hideMDT() {
    document.getElementById('mdt-container').style.display = 'none';
}




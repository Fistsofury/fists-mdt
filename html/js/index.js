// index.js

document.addEventListener('DOMContentLoaded', () => {
    // Listen for the form submission
    document.getElementById('new-case-form').addEventListener('submit', submitNewCase);

    // Event listeners for the navigation buttons
    document.getElementById('open-new-case').addEventListener('click', openNewCaseSection);
    document.getElementById('view-old-records').addEventListener('click', viewOldRecordsSection);
    document.getElementById('close-mdt').addEventListener('click', closeMDT);
    document.getElementById('surname').addEventListener('input', handleAutocomplete);
    document.getElementById('first-name').addEventListener('input', handleAutocomplete);

    // Placeholder for initializing other functionalities on page load
});

window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === 'openMDT') {
        showMDT();
    } else if (data.type === 'closeMDT') {
        hideMDT();
    }
});

window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === 'openMDT') {
        showMDT();
    } else if (data.type === 'closeMDT') {
        hideMDT();
    } else if (data.type === 'populateCrimeData') {
        populateCrimeDropdowns(data.crimeData);
    }
});


// Function to handle new case submission
function submitNewCase(event) {
    event.preventDefault(); // Prevent the form from submitting in the traditional way

    let formData = new FormData(event.target);
    let caseData = {};
    formData.forEach((value, key) => { caseData[key] = value; });

    // Send the case data to the server via NUI
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

// Function to display the new case section
function openNewCaseSection() {
    document.getElementById('new-case-form-section').style.display = 'block';
    document.getElementById('old-records-section').style.display = 'none';
}

// Function to display the old records section
function viewOldRecordsSection() {
    document.getElementById('new-case-form-section').style.display = 'none';
    document.getElementById('old-records-section').style.display = 'block';
    // Fetch and display the old records from the server
    // Placeholder for fetching logic
}

// Function to close the MDT interface
function closeMDT() {
    fetch(`https://${GetParentResourceName()}/fists-mdt:close`, { method: 'POST' })
    .then(() => {
        // Close the MDT window or perform other cleanup actions
    }).catch(error => console.error('Error closing MDT:', error));
}

// Function to handle the autocomplete for names
function handleAutocomplete(event) {
    const inputField = event.target;
    const inputType = inputField.id; // 'surname' or 'first-name'
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

function closeMDT() {
    fetch(`https://${GetParentResourceName()}/fists-mdt:close`, { method: 'POST' })
    .then(() => {
        hideMDT(); // This function should hide the MDT interface
    }).catch(error => console.error('Error closing MDT:', error));
}


function populateCrimeDropdowns(crimeData) {
    const crimeCategorySelect = document.getElementById('crime-category');
    crimeCategorySelect.innerHTML = ''; // Clear existing options

    // Populate crime categories
    for (const category in crimeData) {
        const option = document.createElement('option');
        option.value = category;
        option.textContent = category;
        crimeCategorySelect.appendChild(option);
    }

    // Listen for changes in the crime category to update specific crimes
    crimeCategorySelect.addEventListener('change', function() {
        const selectedCategory = this.value;
        populateSpecificCrimeDropdown(crimeData[selectedCategory]);
    });
}

// Function to populate the specific crime dropdown based on selected category
function populateSpecificCrimeDropdown(specificCrimes) {
    const specificCrimeSelect = document.getElementById('specific-crime');
    specificCrimeSelect.innerHTML = ''; // Clear existing options

    for (const crime in specificCrimes) {
        const option = document.createElement('option');
        option.value = crime;
        option.textContent = crime;
        specificCrimeSelect.appendChild(option);
    }

    // Update fine and sentence fields based on the selected specific crime
    specificCrimeSelect.addEventListener('change', function() {
        const selectedCrime = specificCrimes[this.value];
        document.getElementById('suggested-fine').value = selectedCrime.fine;
        document.getElementById('suggested-sentence').value = selectedCrime.sentence;
    });
}


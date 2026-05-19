export default function SubmitDocSection({
     submitDocOptions = [],
     selectedDocs = [],
     setSelectedDocs 
    }) {
    return (
        <section className="form-card">
            <h2 className="form-card-title">제출 서류</h2>
            <div>
                {submitDocOptions.map((doc, i) => (
                    <div key={i}>
                        <input
                            type="checkbox"
                            id={doc.value}
                            checked={selectedDocs.includes(doc.value)}
                            onChange={(e) => {
                                if (e.target.checked) {
                                    setSelectedDocs([...selectedDocs, doc.value]);
                                } else {
                                    setSelectedDocs(selectedDocs.filter(d => d !== doc.value));
                                }
                            }}
                        />
                        <label htmlFor={doc.value}>{doc.label}</label>
                    </div>
                ))}
            </div>
        </section>
    );
}
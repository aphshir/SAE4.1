class path{
    constructor(){
        this.getVariables().then(data => {
            this.variables = data;
        });
    }

    async getVariables(){
        let response = await fetch("http://localhost:3000/variables");
        let data = await response.json();
        return data;
    }
}
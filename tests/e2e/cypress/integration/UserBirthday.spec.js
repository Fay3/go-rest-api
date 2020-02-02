it('Incorrect Username: should return error message of letters only', () => {
    cy.request({
        method: 'PUT',
        url: '/hello/john801',
        failOnStatusCode: false,
        body: {
            name: 'john jones',
            dob: '1988-01-19'
        }
    })
        .then((response) => {
            expect(response.status).to.eq(422)
            expect(response.body).to.have.property('message', ' john801 must contains only letters')
        })
})

it('Incorrect DOB: should return error message of before todays date only', () => {
    cy.request({
        method: 'PUT',
        url: '/hello/john',
        failOnStatusCode: false,
        body: {
            name: 'john jones',
            dob: '2028-01-01'
        }
    })
        .then((response) => {
            expect(response.status).to.eq(422)
            expect(response.body).to.have.property('message', ' 2028-01-01 must be a date before todays date')
        })
})

it('Create User: should create user if they do not exist', () => {
    cy.request('PUT', '/hello/john', { name: 'john jones', dob: '1988-01-19' })
        .then((response) => {
            expect(response.status).to.eq(200)
        })
})

it('Update User: should update user and return 204', () => {
    cy.request('PUT', '/hello/john', { name: 'john jones', dob: '1989-01-19' })
        .then((response) => {
            expect(response.status).to.eq(204)
        })
})

it('Create User: with todays date and month', () => {
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0');
    const dob = '1984' + '-' + mm + '-' + dd;
    cy.request('PUT', '/hello/steven', {
        name: 'steven test', dob: `${dob}`
    })
        .then((response) => {
            expect(response.status).to.eq(200)
        })
})

it('Request User: should get remaining days until birthday', () => {
    cy.request('GET', '/hello/john')
        .then((response) => {
            expect(response.status).to.eq(200)
            expect(response.body).to.have.property('message', 'Hello, john your birthday is in 351 day(s)')
        })
})

it('Request User: should get remaining days until birthday', () => {
    cy.request('GET', '/hello/steven')
        .then((response) => {
            expect(response.status).to.eq(200)
            expect(response.body).to.have.property('message', 'Hello, steven! Happy Birthday')
        })
})
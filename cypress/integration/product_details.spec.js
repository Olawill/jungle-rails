describe('first', () => {
  beforeEach(() => {
    cy.visit('http://localhost:3000')

    cy.get(".products article").first().click()
  })

  it('should allow product be clicked for more detail', () => {
    cy.get(".product-detail").should('be.visible')
  })
})
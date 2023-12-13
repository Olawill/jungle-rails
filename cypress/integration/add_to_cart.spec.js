describe('Add to Cart', () => {
  beforeEach(() => {
    cy.visit('http://localhost:3000')
  })

  it('should allow products be added to cart from homepage', () => {
    // Get initial cart quantity
    cy.get('.nav-link').contains('My Cart').invoke('text').as('initialQuantity');

    // FORCE THE CLICK
    // ELEMENT HIDDING BEHIND ANOTHER ELEMENT
    cy.get('.products article').first()
      .find('button').should('be.visible').click({ force: true });

    // Get updated cart quantity
    cy.get('.nav-link').contains('My Cart').invoke('text').as('updatedQuantity');

    // Assert that the updated quantity is one more than the initial quantity
    cy.get('@initialQuantity').then(initialQuantity => {
      cy.get('@updatedQuantity').then(updatedQuantity => {
        const initialQty = parseInt(initialQuantity.match(/\d+/)[0], 10);
        const updatedQty = parseInt(updatedQuantity.match(/\d+/)[0], 10);
        expect(updatedQty).to.equal(initialQty + 1);
      });
    });
  });
})
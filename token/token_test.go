package token

import (
	"testing"
)

func TestPrecedence(t *testing.T) {
	prec := ADD.Precedence()

	if prec != 4 {
		t.Error("ADD should have 4 but has", prec)
	}
}

func TestPrecedenceNonOp(t *testing.T) {
	prec := ILLEGAL.Precedence()

	if prec != LowestPrec {
		t.Error("ILLEGAL should have", LowestPrec, "but has", prec)
	}
}

func TestIsLiteral(t *testing.T) {
	if !STRING.IsLiteral() {
		t.Error("STRING should be a literal but isn't")
	}
}

func TestIsLiteralFail(t *testing.T) {
	if MUL.IsLiteral() {
		t.Error("MUL shouldn't be a literal but is")
	}
}

func TestIsOperator(t *testing.T) {
	if !ADD.IsOperator() {
		t.Error("ADD should be a operator but isn't")
	}
}

func TestIsOperatorDelimiter(t *testing.T) {
	if !SEMICOLON.IsOperator() {
		t.Error("SEMICOLON should be a operator but isn't")
	}
}

func TestIsOperatorFail(t *testing.T) {
	if NUM.IsOperator() {
		t.Error("NUM shouldn't be a operator but is")
	}
}

func TestIsKeyword(t *testing.T) {
	if !RETURN.IsKeyword() {
		t.Error("RETURN should be a keyword but isn't")
	}
}

func TestIsKeywordFail(t *testing.T) {
	if LOR.IsKeyword() {
		t.Error("LOR shouldn't be a keyword but is")
	}
}

func TestLookup(t *testing.T) {
	tok := Lookup("IF")

	if tok != IF {
		t.Error("IF didn't return IF token")
	}
}

func TestLookupFail(t *testing.T) {
	tok := Lookup("ADD")

	if tok != ILLEGAL {
		t.Error("ADD non keyword should've returned ILLEGAL but didn't")
	}
}

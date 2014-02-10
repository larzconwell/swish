// Package token defines variables and types to represet the various
// tokens in the Swish language.
package token

// Levels of precedence for expression parsing. Non operators have lowest
// precedence, followed by operators, starting from 1 to unary operators with
// 6, the highest precedence serves as a catch all precedence for indexing, and
// other operators and delimiter tokens.
const (
	LowestPrec = 0
	UnaryPrec  = 6
	HighetPrec = 7
)

// The list of tokens.
const (
	ILLEGAL Token = iota
	EOF
	COMMENT

	// Basic type literals.
	literal_begin
	NUM    // 12345, 123.45, -12e5
	STRING // `abc`, 'abc', "${variable}"
	literal_end

	// Operators and delimiters.
	operator_begin
	ADD // +
	SUB // -
	MUL // *
	QUO // /
	REM // %

	LAND // &&
	LOR  // ||
	INC  // ++
	DEC  // --

	ADD_ASSIGN // +=
	SUB_ASSIGN // -=
	MUL_ASSIGN // *=
	QUO_ASSIGN // /=
	REM_ASSIGN // %=

	LAND_ASSIGN // &&=
	LOR_ASSIGN  // ||=

	EQL    // ==
	LSS    // <
	GTR    // >
	ASSIGN // =
	NOT    // !

	NEG      // !=
	LEQ      // <=
	GEQ      // >=
	ELLIPSIS // ...

	LPAREN // (
	LBRACK // [
	LBRACE // {
	COMMA  // ,

	RPAREN    // )
	RBRACK    // ]
	RBRACE    // }
	SEMICOLON // ;
	COLON     // :
	operator_end

	// Keywords.
	keyword_begin
	IF
	ELSE

	FOR
	IN
	UNTIL

	BREAK
	CONTINUE
	FALLTHROUGH

	SWITCH
	CASE
	DEFAULT

	RETURN
	keyword_end
)

// keywords contains the keywords tokens mapping to their string
// representation.
var keywords = [...]string{
	IF:   "IF",
	ELSE: "ELSE",

	FOR:   "FOR",
	IN:    "IN",
	UNTIL: "UNTIL",

	BREAK:       "BREAK",
	CONTINUE:    "CONTINUE",
	FALLTHROUGH: "FALLTHROUGH",

	SWITCH:  "SWITCH",
	CASE:    "CASE",
	DEFAULT: "DEFAULT",

	RETURN: "RETURN",
}

// Token represents a single Swish token.
type Token int

// Precedence returns the operator precedence of the given binary operator
// token. If the token is not a binary operator the result is LowestPrec.
func (tok Token) Precedence() int {
	switch tok {
	case LOR:
		return 1
	case LAND:
		return 2
	case EQL, NEG, LSS, LEQ, GTR, GEQ:
		return 3
	case ADD, SUB:
		return 4
	case MUL, QUO, REM:
		return 5
	}

	return LowestPrec
}

// IsLiteral checks if a token is a basic type literal.
func (tok Token) IsLiteral() bool {
	return literal_begin < tok && tok < literal_end
}

// IsOperator checks if a token is an operator or delimiter.
func (tok Token) IsOperator() bool {
	return operator_begin < tok && tok < operator_end
}

// IsKeyword checks if a token is a keyword.
func (tok Token) IsKeyword() bool {
	return keyword_begin < tok && tok < keyword_end
}

// Lookup maps an identifier to its keyword token. If not a keyword token,
// ILLEGAL is returned.
func Lookup(keyword string) Token {
	for i := keyword_begin + 1; i < keyword_end; i++ {
		if keywords[i] == keyword {
			return i
		}
	}

	return ILLEGAL
}

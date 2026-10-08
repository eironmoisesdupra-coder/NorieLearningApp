import '../../domain/norie_content_models.dart';
import 'authored_lesson_visual.dart';
import 'subject_lesson_builder.dart';

const advancedMathVisuals = <String, AuthoredLessonVisual>{
  'mathematics-g11-authored': AuthoredLessonVisual(
      title: 'Pair opposite terms',
      labels: [
        'Forward: 3, 7, 11, 15, 19',
        'Reverse: 19, 15, 11, 7, 3',
        'Each pair = 22; five pairs = 110',
        'Original sum = 110/2 = 55'
      ],
      details: [
        'An arithmetic sequence adds four each time.',
        'Reversing order leaves the sum unchanged.',
        'Combining the two copies pairs first with last.',
        'Divide by two because every term was counted twice.'
      ],
      note: 'Sₙ = n(a₁ + aₙ)/2 follows from pairing two copies.',
      ordered: true),
  'mathematics-g12-authored': AuthoredLessonVisual(
      title: 'Fixed perimeter, varying rectangle',
      labels: [
        'A(x) = x(20 − x)',
        'A′(x) = 20 − 2x',
        'x < 10: positive derivative',
        'x > 10: negative derivative'
      ],
      details: [
        'Perimeter forty gives width twenty minus length.',
        'The rate of area change vanishes at x = 10.',
        'Area increases toward the critical point.',
        'Area decreases after the critical point.'
      ],
      note:
          'The feasible domain is 0 < x < 20; the maximum is 100 square units at x = 10.'),
  'mathematics-college-authored': AuthoredLessonVisual(
      title: 'Matrix columns are basis images',
      labels: [
        'A = [[2, 0], [0, 3]]',
        'e₁ = (1, 0) → (2, 0)',
        'e₂ = (0, 1) → (0, 3)',
        '(1, 2) → 1(2, 0) + 2(0, 3) = (2, 6)'
      ],
      details: [
        'The first coordinate scales by two, the second by three.',
        'The first column is the image of the first basis vector.',
        'The second column is the image of the second basis vector.',
        'Linearity combines basis images using the input coordinates.'
      ],
      note:
          'Vectors are columns; the notation [[a,b],[c,d]] lists matrix rows.'),
};

final advancedMathematics = <String, NorieTopicContent>{
  'g11': subjectLesson(
      subject: 'Mathematics',
      grade: 'g11',
      title: 'Sums of Arithmetic Sequences',
      prerequisite: 'mathematics.g11.intro-calculus',
      objectives: [
        'Find an arithmetic sequence term from its common difference.',
        'Derive the finite sum by pairing terms.',
        'Distinguish a term from the sum of several terms.'
      ],
      introduction:
          'Saving an amount that increases by the same increment creates an arithmetic sequence. To find the total saved, we need a sum, not just the amount in the final week.',
      explanation:
          'An arithmetic sequence has a fixed common difference d. Its nth term is aₙ = a₁ + (n − 1)d. There are n − 1 increments from the first term to the nth, because the first term occurs before any increment. To find the first n terms total, write the sequence forward and backward. Each paired position sums to a₁ + aₙ. The two copies contain n such pairs. Dividing by two gives Sₙ = n(a₁ + aₙ)/2. Equivalently, Sₙ = n[2a₁ + (n − 1)d]/2.',
      application:
          'For 3, 7, 11, 15, 19, the fifth term is nineteen but the sum is fifty-five. Negative differences are allowed: 20, 17, 14, 11 has d = −3. The same formula works because opposite pairs still have equal sums. A constant ratio instead of a constant difference describes a geometric sequence and needs another sum formula. Read the problem carefully to decide whether it asks for one indexed term, a number of terms, or a cumulative total.',
      worked:
          'Save ten credits in week one, then three more than the previous week for ten weeks. Step 1: a₁ = 10, d = 3, n = 10. Step 2: a₁₀ = 10 + 9 × 3 = 37. Step 3: S₁₀ = 10(10 + 37)/2 = 235 credits. The final deposit is thirty-seven; the total is 235.',
      guided:
          'Find the sixth term and first-six-term sum of 8, 12, 16, … . Show why five differences lead to the sixth term.',
      solution:
          'a₆ = 8 + (6 − 1)4 = 28. Then S₆ = 6(8 + 28)/2 = 108. Five steps connect the first term to the sixth.',
      mistakes:
          'Use n − 1 differences when finding aₙ. Do not confuse aₙ with Sₙ. Divide by two in the pairing formula because the forward and reverse lists count every original term twice. Confirm a common difference exists before using this sum.',
      recap:
          'Arithmetic terms follow aₙ = a₁ + (n − 1)d. Pairing two copies yields Sₙ = n(a₁ + aₙ)/2. Identify whether the requested answer is a term or cumulative sum.',
      visual: advancedMathVisuals['mathematics-g11-authored']!,
      questions: [
        'What is the common difference of 3, 7, 11, 15?|4|3|7|2|Each consecutive term is four more than its predecessor.|Arithmetic sequence',
        'Which formula gives the nth arithmetic term?|a₁ + (n − 1)d|a₁ + nd always|a₁dⁿ|n(a₁ + d)/2 always|There are n minus one increments after the first term.|Term formula',
        'Why divide by two in the paired sum formula?|Two copies counted each term twice|Every term is even|Half the sequence is missing|The difference must be two|The forward and backward lists contain two copies of the original sum.|Sum derivation',
        'The fifth term of 3, 7, 11, 15, 19 is what?|19|55|15|22|The fifth indexed value is nineteen, distinct from the total of all five.|Term and sum',
        'The sum of 3, 7, 11, 15, 19 is what?|55|19|22|110|Five times the first-plus-last sum twenty-two divided by two gives fifty-five.|Sum calculation',
        'Which sequence is arithmetic?|20, 17, 14, 11|2, 4, 8, 16|1, 4, 9, 16|3, 5, 9, 17|The first sequence has constant difference negative three.|Arithmetic sequence',
        'How many common-difference steps lead from a₁ to a₁₀?|9|10|11|1|The first term precedes any step, so reaching term ten needs nine increments.|Term formula',
        'A constant ratio but changing difference suggests what?|A geometric sequence|An arithmetic sequence necessarily|A sum of zero|No mathematical pattern|A fixed multiplicative ratio defines a geometric rather than arithmetic pattern.|Model choice',
        'Find the sixth term of 8, 12, 16, … .|28|32|24|108|Use eight plus five increments of four to reach twenty-eight.|Term calculation',
        'Find the first-six-term sum of 8, 12, 16, … .|108|28|216|96|The sixth term is twenty-eight, so six times thirty-six divided by two is 108.|Sum calculation',
        'Ten weekly deposits start at 10 and increase by 3. Total deposited is what?|235|37|370|130|The tenth term is thirty-seven; the paired sum is 10(10 + 37)/2 = 235.|Application',
      ]),
  'g12': subjectLesson(
      subject: 'Mathematics',
      grade: 'g12',
      title: 'Optimizing a Rectangle with Derivatives',
      prerequisite: 'mathematics.g12.applied-mathematics',
      objectives: [
        'Build an area function from a perimeter constraint.',
        'Find a critical point using a derivative.',
        'Justify a maximum within the feasible domain.'
      ],
      introduction:
          'A fixed fence length permits many rectangles. Calculus can identify the dimensions with greatest area by connecting the physical constraint to a function and examining its rate of change.',
      explanation:
          'Let a rectangle have length x and width y with perimeter forty units. Then 2x + 2y = 40, so y = 20 − x. Its area is A(x) = xy = x(20 − x) = 20x − x². Both dimensions must be positive, giving the feasible domain 0 < x < 20. Differentiate using the power rule: A′(x) = 20 − 2x. A critical point occurs where this derivative is zero, so x = 10. A zero derivative is a candidate, not by itself proof of a maximum.',
      application:
          'For x below ten, A′ is positive, so area increases as x increases. For x above ten, it is negative, so area decreases. This sign change proves a maximum at x = 10, giving y = 10 and area 100 square units. Alternatively A″ = −2 is negative throughout the domain, showing concavity downward. The area approaches zero at either degenerate boundary. Always check domain restrictions and endpoints when included. A stationary point could be a minimum in another model.',
      worked:
          'Use perimeter twenty-four units. Step 1: y = 12 − x. Step 2: A = 12x − x² for 0 < x < 12. Step 3: A′ = 12 − 2x = 0 gives x = 6. Step 4: A″ = −2 confirms a maximum. Step 5: y = 6 and maximum area is 36 square units. The result satisfies 2(6) + 2(6) = 24.',
      guided:
          'For perimeter sixty units, write width in terms of length, form the area function, find the stationary point, and verify the maximum area. State the feasible domain.',
      solution:
          'y = 30 − x and A = 30x − x² on 0 < x < 30. A′ = 30 − 2x vanishes at x = 15. Since A″ = −2, this is a maximum. Both sides are fifteen and area is 225 square units.',
      mistakes:
          'The perimeter includes both lengths and both widths. Differentiate the area function, not the perimeter constant. A stationary point outside the feasible domain is invalid. Give squared units for area and justify maximum rather than merely solving A′ = 0.',
      recap:
          'Translate a constraint into one variable, state its domain, differentiate the objective, and test candidates. For this fixed-perimeter rectangle model, the maximizing rectangle is a square.',
      visual: advancedMathVisuals['mathematics-g12-authored']!,
      questions: [
        'Perimeter is forty. If length is x, width is what?|20 − x|40 − x|40 − 2x|x − 20|From 2x + 2y = 40, divide by two and solve for y.|Constraint',
        'A rectangle has perimeter forty units and length x, with both sides positive. Which area function follows this constraint?|20x − x²|40x|20 − x|x² only|Multiply length x by width twenty minus x.|Model construction',
        'Differentiate A(x) = 20x − x².|20 − 2x|20x − 2|40 − x|20 + 2x|The derivative of twenty x is twenty and of negative x squared is negative two x.|Derivative',
        'Where does A′ = 20 − 2x vanish?|x = 10|x = 20|x = 0|x = 40|Solve twenty minus two x equals zero to obtain ten.|Critical point',
        'Why is a zero derivative not sufficient alone to prove a maximum?|It may also mark a minimum or other stationary point|Every derivative is zero|It removes the domain|It changes the perimeter|Stationary points need classification within the feasible domain.|Maximum test',
        'What is the feasible domain for positive sides with perimeter forty?|0 < x < 20|x > 40 only|All real x|x < 0 only|Both x and twenty minus x must remain positive.|Domain',
        'At x = 10 with perimeter forty, area is what?|100 square units|40 square units|20 square units|10 square units|Both dimensions are ten, so the area is ten times ten.|Application',
        'What does A″ = −2 show here?|Concavity downward|A minimum necessarily|A vertical line|Area is negative everywhere|A negative second derivative supports a maximum at the stationary point.|Maximum test',
        'For perimeter twenty-four, maximizing side lengths are what?|6 and 6|12 and 12|4 and 8|3 and 9|The area 12x minus x squared is maximized at x = six.|Application',
        'For perimeter sixty, maximum rectangle area is what?|225 square units|900 square units|60 square units|30 square units|A square with side fifteen has perimeter sixty and area 225.|Application',
        'A calculated stationary point makes width negative. What should happen?|Reject it as outside the physical domain|Accept it because derivatives allow it|Call it maximum automatically|Ignore the constraint|A valid physical rectangle must satisfy positive dimensions and the stated constraint.|Domain',
      ]),
  'college': subjectLesson(
      subject: 'Mathematics',
      grade: 'college',
      title: 'Matrices as Linear Transformations',
      prerequisite: 'mathematics.college.linear-algebra',
      objectives: [
        'Compute a matrix image of a column vector.',
        'Interpret matrix columns as basis-vector images.',
        'Use determinant and composition to reason about transformations.'
      ],
      introduction:
          'A two-by-two matrix can describe a linear transformation of the plane. Its entries encode what happens to basis vectors, allowing us to compute other vector images through linear combinations.',
      explanation:
          'Using column vectors, A = [[a, b], [c, d]] sends (x, y) to (ax + by, cx + dy). The first column (a, c) is the image of e₁ = (1, 0), and the second (b, d) is the image of e₂ = (0, 1). Since (x, y) = xe₁ + ye₂, linearity gives A(x, y) = xAe₁ + yAe₂. A matrix transformation preserves addition and scalar multiplication and sends zero to zero. A translation by a nonzero vector is not linear in this two-dimensional representation because it moves zero.',
      application:
          'The diagonal matrix [[2, 0], [0, 3]] scales horizontal coordinates by two and vertical coordinates by three. Its determinant is six, the signed area factor; absolute determinant gives area scaling. A zero determinant means the transformation collapses area and is not invertible. Matrix products encode composition: ABv applies B first, then A. Order matters in general. A rotation followed by unequal axis scaling can differ from scaling followed by rotation. Keep the column-vector convention consistent.',
      worked:
          'Let A = [[1, 2], [0, 1]] and v = (3, 4). Step 1: first output = 1 × 3 + 2 × 4 = 11. Step 2: second output = 0 × 3 + 1 × 4 = 4. Step 3: Av = (11, 4). The matrix shears the plane, shifting horizontal position by twice the vertical coordinate. Its determinant is one, so area is preserved although shapes can change.',
      guided:
          'Use D = [[2, 0], [0, 3]] on v = (1, 2). Find the output and area factor. Then explain why adding the same fixed vector to every point is not a linear map unless that vector is zero.',
      solution:
          'Dv = (2, 6) and det D = 2 × 3 − 0 = 6. A nonzero translation sends zero to that fixed vector, violating the requirement that a linear map send zero to zero.',
      mistakes:
          'Do not multiply coordinatewise against an arbitrary row without summing its two contributions. Columns, not rows, are basis images under this convention. Apply the rightmost matrix first in composition. Area preservation does not guarantee preservation of lengths or angles.',
      recap:
          'A matrix combines basis images to transform column vectors. Determinant describes signed area change and invertibility in two dimensions. Matrix products compose maps in right-to-left order, and nonzero translation is not linear here.',
      visual: advancedMathVisuals['mathematics-college-authored']!,
      questions: [
        'Under column-vector convention, what is the first column of A?|The image of (1, 0)|The image of (0, 1) always|The inverse of A always|The sum of every input|Multiplying A by the first basis vector selects its first column.|Basis images',
        '[[2, 0], [0, 3]] sends (1, 2) to what?|(2, 6)|(3, 2)|(2, 3)|(1, 6)|Each coordinate is scaled by its corresponding diagonal entry.|Matrix calculation',
        '[[1, 2], [0, 1]] sends (3, 4) to what?|(11, 4)|(3, 8)|(7, 4)|(11, 0)|The first row gives three plus eight; the second gives four.|Matrix calculation',
        'A linear transformation must send zero to what?|Zero|A fixed nonzero vector|The first matrix row|Any point equally|Preserving scalar multiplication and addition implies zero maps to zero.|Linearity',
        'The determinant of [[2, 0], [0, 3]] is what?|6|5|0|1|For a two-by-two matrix, determinant is ad minus bc.|Determinant',
        'What does a zero determinant imply for a square two-by-two map?|It is not invertible|It preserves all areas|It must be identity|It is a nonzero translation|Zero determinant means area collapses and an inverse does not exist.|Invertibility',
        'In ABv, which map acts first on v?|B|A|Both in arbitrary order|Neither|With column vectors, the rightmost multiplication acts first.|Composition',
        'Does determinant one guarantee all lengths are preserved?|No; a shear can preserve area but change lengths|Yes for every matrix|Yes because all entries equal one|No because determinant has no meaning|Determinant controls area change, not necessarily length or angle.|Geometry',
        '[[3, 1], [2, 0]] sends (2, 4) to what?|(10, 4)|(6, 8)|(7, 2)|(10, 0)|Row sums give three times two plus four, and two times two.|Matrix calculation',
        'What is det [[1, 2], [0, 1]]?|1|3|2|0|The determinant is one times one minus two times zero.|Determinant',
        'Why is translation by (1, 0) not linear in this representation?|It sends zero to (1, 0)|It has a name|It leaves every vector fixed|It uses only integers|A nonzero translation violates the zero-to-zero property of linear maps.|Linearity',
      ]),
};

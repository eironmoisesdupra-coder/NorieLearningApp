import '../../domain/norie_content_models.dart';

abstract final class NorieAdditionalSubjectCurriculum {
  static final Map<String, List<NorieTopicContent>> _filipino = {
    'g1': _buildPath(
      subject: 'Filipino',
      gradeLabel: 'Grade 1',
      accent: 'violet',
      specs: const [
        _LessonSpec(
          slug: 'alpabeto-at-tunog',
          title: 'Alpabeto at Tunog',
          introduction:
              'Kilalanin ang mga titik at ang karaniwang tunog na kinakatawan ng mga ito sa payak na salitang Filipino.',
          keyConcept:
              'Ang titik ay nakikitang simbolo; ang tunog ay naririnig sa pagbigkas.',
          points: [
            'May malaking at maliit na anyo ang mga titik.',
            'Ang unang tunog ng salita ay tumutulong sa pagkilala sa titik.',
            'Makinig sa tunog bago piliin ang titik na tumutugma rito.',
          ],
          conceptId: 'filipino.g1.titik-tunog',
          conceptLabel: 'Pag-uugnay ng titik at tunog',
          questions: [
            _Q('Ano ang unang titik ng salitang "bola"?', ['B', 'D', 'P', 'T'],
                0, 'Ang salitang bola ay nagsisimula sa titik B.'),
            _Q(
                'Aling salita ang nagsisimula sa tunog /m/?',
                ['mesa', 'sako', 'lobo', 'pito'],
                0,
                'Ang mesa ay nagsisimula sa tunog /m/.'),
            _Q('Ano ang maliit na anyo ng titik A?', ['a', 'e', 'o', 'u'], 0,
                'Ang maliit na anyo ng A ay a.'),
            _Q(
                'Aling pares ang magkaparehong titik?',
                ['G at g', 'G at k', 'B at d', 'P at b'],
                0,
                'Ang G at g ay malaking at maliit na anyo ng iisang titik.'),
            _Q(
                'Anong titik ang kumakatawan sa unang tunog ng "tasa"?',
                ['T', 'S', 'A', 'R'],
                0,
                'Ang tasa ay nagsisimula sa tunog /t/.'),
          ],
          challenges: [
            _Q('Piliin ang titik na babagay sa _uso upang mabuo ang "puso".',
                ['P', 'B', 'M'], 0, 'Ang P + uso ay bumubuo sa salitang puso.'),
            _Q(
                'Aling salita ang HINDI nagsisimula sa tunog /b/?',
                ['bata', 'baso', 'mesa'],
                2,
                'Ang mesa ay nagsisimula sa /m/, hindi /b/.'),
            _Q(
                'Kung ang unang tunog ay /l/, alin ang maaaring salita?',
                ['lapis', 'gatas', 'saging'],
                0,
                'Ang lapis ay nagsisimula sa /l/.'),
          ],
        ),
        _LessonSpec(
          slug: 'pantig-at-payak-na-salita',
          title: 'Pantig at Payak na Salita',
          introduction:
              'Hatiin at buuin ang payak na salita gamit ang mga pantig na malinaw na naririnig sa pagbigkas.',
          keyConcept:
              'Ang pantig ay bahagi ng salita na binibigkas sa isang bagsak ng tinig.',
          points: [
            'Maaaring palakpakang bilangin ang pantig.',
            'Ang "ba-ta" ay may dalawang pantig.',
            'Kapag pinagsama ang tamang pantig, nabubuo ang salita.',
          ],
          conceptId: 'filipino.g1.pantig',
          conceptLabel: 'Pagkilala at pagbuo ng pantig',
          questions: [
            _Q('Ilang pantig ang salitang "bata"?', ['2', '1', '3', '4'], 0,
                'Ang bata ay ba-ta, kaya dalawang pantig.'),
            _Q(
                'Alin ang wastong paghahati ng "mesa"?',
                ['me-sa', 'mes-a', 'm-esa', 'mesa-'],
                0,
                'Ang mesa ay nahahati sa me-sa.'),
            _Q(
                'Anong salita ang mabubuo sa "la" + "pis"?',
                ['lapis', 'lapi', 'pisla', 'pila'],
                0,
                'Ang la at pis ay bumubuo sa lapis.'),
            _Q('Alin ang may isang pantig?', ['bahay', 'guro', 'mesa', 'bus'],
                3, 'Ang bus ay binibigkas sa isang pantig.'),
            _Q('Ilang pantig ang "saging"?', ['2', '1', '3', '4'], 0,
                'Ang saging ay sa-ging, kaya dalawang pantig.'),
          ],
          challenges: [
            _Q('Pagsamahin: "pa" + "so".', ['paso', 'sopa', 'puso'], 0,
                'Ang pa at so ay bumubuo sa paso.'),
            _Q('Aling salita ang may tatlong pantig?',
                ['kamatis', 'lapis', 'bola'], 0, 'Ang kamatis ay ka-ma-tis.'),
            _Q(
                'Alin ang wastong pantig ng "gatas"?',
                ['ga-tas', 'gat-as', 'g-atas'],
                0,
                'Ang gatas ay ga-tas: dalawang pantig, ga at tas.'),
          ],
        ),
        _LessonSpec(
          slug: 'pangngalan',
          title: 'Pangngalan',
          introduction:
              'Kilalanin ang mga salitang ngalan ng tao, hayop, bagay, at lugar sa pang-araw-araw na pangungusap.',
          keyConcept:
              'Ang pangngalan ay salitang ginagamit na ngalan ng tao, hayop, bagay, o lugar.',
          points: [
            'Ang "Ana" ay ngalan ng tao.',
            'Ang "paaralan" ay ngalan ng lugar.',
            'Ang "aso" at "lapis" ay mga pangngalan din.',
          ],
          conceptId: 'filipino.g1.pangngalan',
          conceptLabel: 'Pagkilala sa pangngalan',
          questions: [
            _Q(
                'Alin ang pangngalan?',
                ['lapis', 'tumakbo', 'maganda', 'mabilis'],
                0,
                'Ang lapis ay ngalan ng bagay.'),
            _Q(
                'Sa "Si Lino ay masaya," alin ang ngalan ng tao?',
                ['Lino', 'masaya', 'ay', 'Si'],
                0,
                'Ang Lino ang ngalan ng tao.'),
            _Q(
                'Alin ang ngalan ng lugar?',
                ['palengke', 'kumain', 'mabait', 'dahan-dahan'],
                0,
                'Ang palengke ay lugar.'),
            _Q(
                'Alin ang ngalan ng hayop?',
                ['pusa', 'umupo', 'malambot', 'agad'],
                0,
                'Ang pusa ay ngalan ng hayop, kaya ito ay pangngalan.'),
            _Q(
                'Sa "Nasa mesa ang libro," alin ang dalawang pangngalan?',
                [
                  'mesa at libro',
                  'nasa at ang',
                  'mesa at nasa',
                  'libro at ang'
                ],
                0,
                'Ang mesa at libro ay parehong ngalan ng bagay.'),
          ],
          challenges: [
            _Q('Alin ang HINDI pangngalan?', ['bahay', 'guro', 'sumulat'], 2,
                'Ang sumulat ay kilos o pandiwa.'),
            _Q(
                'Piliin ang pangngalang tumutukoy sa tao.',
                ['doktor', 'ospital', 'gamot'],
                0,
                'Ang doktor ay ngalan ng taong gumagamot, kaya ito ay pangngalan.'),
            _Q(
                'Piliin ang pangngalang tumutukoy sa lugar.',
                ['silid-aralan', 'mag-aaral', 'aklat'],
                0,
                'Ang silid-aralan ay lugar.'),
          ],
        ),
        _LessonSpec(
          slug: 'pandiwa',
          title: 'Pandiwa',
          introduction:
              'Tukuyin ang salitang nagsasabi ng kilos o ginagawa ng tao o hayop sa payak na pangungusap.',
          keyConcept: 'Ang pandiwa ay salitang nagsasaad ng kilos o gawain.',
          points: [
            'Ang "tumakbo" ay kilos.',
            'Ang "kumain" ay nagsasabi ng ginawa.',
            'Hanapin kung ano ang ginagawa ng tao o hayop upang makita ang pandiwa.',
          ],
          conceptId: 'filipino.g1.pandiwa',
          conceptLabel: 'Pagkilala sa pandiwa',
          questions: [
            _Q('Alin ang pandiwa?', ['sumulat', 'lapis', 'masaya', 'paaralan'],
                0, 'Ang sumulat ay kilos.'),
            _Q(
                'Sa "Uminom si Ben ng tubig," ano ang kilos?',
                ['uminom', 'Ben', 'tubig', 'si'],
                0,
                'Ang uminom ang kilos na ginawa ni Ben.'),
            _Q(
                'Alin ang nagsasaad ng kilos?',
                ['tumalon', 'mataas', 'bola', 'bata'],
                0,
                'Ang tumalon ay kilos.'),
            _Q(
                'Sa "Natulog ang pusa," ano ang pandiwa?',
                ['natulog', 'pusa', 'ang', 'wala'],
                0,
                'Ang natulog ang kilos ng pusa.'),
            _Q(
                'Alin ang HINDI pandiwa?',
                ['mesa', 'kumanta', 'naglakad', 'umupo'],
                0,
                'Ang mesa ay bagay, hindi kilos.'),
          ],
          challenges: [
            _Q('Ano ang pandiwa sa "Nagbasa si Mia"?', ['nagbasa', 'Mia', 'si'],
                0, 'Ang nagbasa ang kilos.'),
            _Q(
                'Piliin ang kilos na maaaring gawin sa bola.',
                ['sipain', 'luntian', 'bilog'],
                0,
                'Ang sipain ay kilos na ginagawa sa bola; hindi ito kulay o hugis.'),
            _Q('Alin ang pandiwa?', ['nagluto', 'kusina', 'masarap'], 0,
                'Ang nagluto ay kilos.'),
          ],
        ),
        _LessonSpec(
          slug: 'pang-uri',
          title: 'Pang-uri',
          introduction:
              'Gamitin ang pang-uri upang ilarawan ang katangian, kulay, laki, o anyo ng tao, hayop, bagay, at lugar.',
          keyConcept: 'Ang pang-uri ay salitang naglalarawan sa pangngalan.',
          points: [
            'Ang "pulang bola" ay gumagamit ng pang-uring pula.',
            'Ang "maliit na pusa" ay naglalarawan ng laki.',
            'Itanong: ano ang katangian ng pangngalan?',
          ],
          conceptId: 'filipino.g1.pang-uri',
          conceptLabel: 'Pagkilala sa pang-uri',
          questions: [
            _Q(
                'Alin ang pang-uri sa "maliit na bahay"?',
                ['maliit', 'bahay', 'na', 'wala'],
                0,
                'Ang maliit ay naglalarawan sa bahay.'),
            _Q(
                'Alin ang salitang naglalarawan?',
                ['pula', 'tumakbo', 'mesa', 'paaralan'],
                0,
                'Ang pula ay maaaring maglarawan ng kulay.'),
            _Q(
                'Sa "mabait na guro," ano ang pang-uri?',
                ['mabait', 'guro', 'na', 'wala'],
                0,
                'Ang mabait ay naglalarawan sa guro.'),
            _Q(
                'Alin ang tamang pang-uri para sa yelo?',
                ['malamig', 'sumulat', 'lapis', 'silid'],
                0,
                'Ang malamig ay katangian ng yelo.'),
            _Q(
                'Alin ang HINDI pang-uri?',
                ['kumain', 'matamis', 'mahaba', 'mabilis'],
                0,
                'Ang kumain ay pandiwa.'),
          ],
          challenges: [
            _Q(
                'Piliin ang pang-uri: "___ na mangga".',
                ['matamis', 'kinain', 'mesa'],
                0,
                'Ang matamis ay naglalarawan sa mangga.'),
            _Q(
                'Ano ang pang-uri sa "malinis na silid"?',
                ['malinis', 'silid', 'na'],
                0,
                'Ang malinis ay katangian ng silid.'),
            _Q('Alin ang naglalarawan ng laki?', ['malaki', 'tumakbo', 'guro'],
                0, 'Ang malaki ay paglalarawan ng laki.'),
          ],
        ),
        _LessonSpec(
          slug: 'payak-na-pangungusap',
          title: 'Payak na Pangungusap',
          introduction:
              'Bumuo at umunawa ng payak na pangungusap na may malinaw na pinag-uusapan at sinasabi tungkol dito.',
          keyConcept:
              'Ang payak na pangungusap ay nagpapahayag ng isang buo at malinaw na diwa.',
          points: [
            'Nagsisimula ang pangungusap sa malaking titik.',
            'Nagtatapos ito sa wastong bantas.',
            'Dapat malinaw kung sino o ano ang pinag-uusapan at ano ang sinasabi tungkol dito.',
          ],
          conceptId: 'filipino.g1.pangungusap',
          conceptLabel: 'Pagbuo ng payak na pangungusap',
          questions: [
            _Q(
                'Alin ang buong pangungusap?',
                ['Masaya ang bata.', 'ang bata', 'masaya', 'bata ang'],
                0,
                'Ang "Masaya ang bata." ay may buo at malinaw na diwa.'),
            _Q(
                'Ano ang dapat gamitin sa simula ng pangungusap?',
                [
                  'Malaking titik',
                  'Kuwit',
                  'Gitling',
                  'Maliit na titik lamang'
                ],
                0,
                'Karaniwang nagsisimula ang pangungusap sa malaking titik.'),
            _Q('Aling bantas ang angkop sa pahayag?', ['.', '?', '!', ','], 0,
                'Ang tuldok ay karaniwang ginagamit sa payak na pahayag.'),
            _Q(
                'Alin ang wastong ayos?',
                [
                  'Si Ana ay nagbabasa.',
                  'nagbabasa Si Ana ay',
                  'Ana ay Si nagbabasa',
                  'ay nagbabasa Ana Si'
                ],
                0,
                'Ang unang pagpipilian ay may malinaw at wastong ayos.'),
            _Q(
                'Alin ang tanong?',
                [
                  'Nasaan ang aklat?',
                  'Nasa mesa ang aklat.',
                  'Aklat sa mesa.',
                  'Ang aklat'
                ],
                0,
                'Ang tandang pananong ay nagpapakitang nagtatanong ang pangungusap.'),
          ],
          challenges: [
            _Q(
                'Ayusin: "bola / ang / bilog / ay".',
                [
                  'Ang bola ay bilog.',
                  'Bilog bola ang ay.',
                  'Bola ay ang bilog.'
                ],
                0,
                'Ang wastong ayos ay "Ang bola ay bilog."'),
            _Q(
                'Alin ang may wastong malaking titik at tuldok?',
                [
                  'Si Ben ay masipag.',
                  'si Ben ay masipag.',
                  'Si Ben ay masipag'
                ],
                0,
                'May malaking titik at tuldok ang unang pangungusap.'),
            _Q(
                'Alin ang kumpletong pangungusap?',
                ['Tumakbo ang aso.', 'ang aso', 'tumakbo', 'aso'],
                0,
                'Ang "Tumakbo ang aso." ay buo ang diwa.'),
          ],
        ),
        _LessonSpec(
          slug: 'pag-unawa-sa-maikling-kuwento',
          title: 'Pag-unawa sa Maikling Kuwento',
          introduction:
              'Tukuyin ang tauhan, lugar, mahahalagang pangyayari, at simpleng aral mula sa maikling kuwentong binasa o pinakinggan.',
          keyConcept:
              'Ang pag-unawa ay pagsagot batay sa mga detalyeng talagang nasa kuwento.',
          points: [
            'Ang tauhan ang gumagawa o nakararanas ng pangyayari.',
            'Ang tagpuan ay lugar o panahong pinangyayarihan.',
            'Ang pagkakasunod-sunod ng pangyayari ay tumutulong sa pag-unawa.',
          ],
          conceptId: 'filipino.g1.pag-unawa',
          conceptLabel: 'Pagkuha ng detalye sa kuwento',
          questions: [
            _Q(
                'Nagtanim si Liza ng buto sa bakuran. Sino ang nagtanim?',
                ['Liza', 'Nena', 'Carlo', 'Ben'],
                0,
                'Si Liza ang nagtanim ayon sa pangungusap.'),
            _Q(
                'Nagtanim si Liza sa bakuran. Saan nangyari ang pagtatanim?',
                ['bakuran', 'aklatan', 'paaralan', 'palengke'],
                0,
                'Nasa bakuran si Liza; ito ang lugar ng pangyayari.'),
            _Q(
                'Kung unang nagtanim si Liza at pagkatapos ay nagdilig, ano ang nauna?',
                ['nagtanim', 'nagdilig', 'umani', 'natulog'],
                0,
                'Ayon sa pagkakasunod, ang pagtatanim ang nauna.'),
            _Q(
                'Diniligan ni Liza ang buto. Pagkaraan ng ilang araw, may tumubong halaman. Ano ang tumubo?',
                ['halaman', 'laruan', 'aklat', 'payong'],
                0,
                'Halaman ang tumubo ayon sa kuwento tungkol kay Liza.'),
            _Q(
                'Inalagaan ni Liza ang halaman at patuloy niya itong diniligan. Alin ang mabuting aral?',
                [
                  'Alagaan ang mga halaman.',
                  'Huwag diligan ang halaman.',
                  'Sirain ang halaman.',
                  'Itapon ang mga buto.'
                ],
                0,
                'Ipinapakita ng pagdidilig ni Liza ang pag-aalaga sa halaman.'),
          ],
          challenges: [
            _Q(
                'Si Nena ay nagdala ng payong dahil umuulan. Bakit siya nagdala nito?',
                ['dahil umuulan', 'dahil mainit', 'dahil gabi'],
                0,
                'Nasa pangungusap mismo ang dahilan: umuulan.'),
            _Q(
                'Nagpunta si Carlo sa aklatan. Ano ang tagpuan?',
                ['aklatan', 'Carlo', 'nagpunta'],
                0,
                'Ang aklatan ang lugar ng pangyayari.'),
            _Q(
                'Una siyang kumain, saka naghugas ng pinggan. Ano ang ikalawang pangyayari?',
                ['naghugas ng pinggan', 'kumain', 'natulog'],
                0,
                'Ang paghuhugas ang nangyari pagkatapos kumain.'),
          ],
        ),
        _LessonSpec(
          slug: 'magalang-na-pakikipag-usap',
          title: 'Magalang na Pakikipag-usap',
          introduction:
              'Pumili ng magalang na salita at tugon kapag nakikipag-usap sa pamilya, guro, kaklase, at ibang tao.',
          keyConcept:
              'Naipapakita ang paggalang sa maayos na tono at angkop na salitang ginagamit.',
          points: [
            'Gamitin ang "po" at "opo" kung angkop sa kausap at sitwasyon.',
            'Ang "salamat" at "pakiusap" ay nagpapakita ng paggalang.',
            'Makinig at hintaying matapos magsalita ang kausap.',
          ],
          conceptId: 'filipino.g1.magandang-pakikipag-usap',
          conceptLabel: 'Magalang na pakikipag-usap',
          questions: [
            _Q(
                'Alin ang magalang na pakiusap?',
                [
                  'Pakibigay po ang aklat.',
                  'Ibigay mo!',
                  'Akin na iyan.',
                  'Bilisan mo.'
                ],
                0,
                'Ang paggamit ng pakiusap at po ay magalang.'),
            _Q(
                'Ano ang sasabihin kapag may tumulong sa iyo?',
                ['Salamat po.', 'Wala.', 'Akin iyan.', 'Umalis ka.'],
                0,
                'Ang pasasalamat ay angkop na tugon sa tulong.'),
            _Q(
                'Kapag may nagsasalita, ano ang magalang gawin?',
                ['Makinig', 'Sumigaw', 'Mang-asar', 'Putulin agad ang salita'],
                0,
                'Ang pakikinig ay pagpapakita ng paggalang.'),
            _Q(
                'Alin ang magalang na pagsagot?',
                ['Opo.', 'Ayoko nga!', 'Ano ba!', 'Tahimik!'],
                0,
                'Ang opo ay magalang na pagsang-ayon sa angkop na sitwasyon.'),
            _Q(
                'Ano ang magandang sabihin kung nais dumaan?',
                ['Makikiraan po.', 'Tabi!', 'Umalis!', 'Diyan ka lang.'],
                0,
                'Ang "Makikiraan po" ay maayos na pakiusap.'),
          ],
          challenges: [
            _Q(
                'May nahiraman kang lapis. Ano ang wastong sabihin sa pagsauli?',
                [
                  'Salamat sa pagpapahiram.',
                  'Akin na ito.',
                  'Kunin mo.',
                  'Wala'
                ],
                0,
                'Ang pasasalamat ay angkop sa taong nagpahiram.'),
            _Q(
                'Nais mong magtanong sa guro. Alin ang pinakamagalang?',
                [
                  'Maaari po ba akong magtanong?',
                  'Hoy, tanong!',
                  'Sagutin mo ito.'
                ],
                0,
                'Ang unang pahayag ay malinaw at magalang.'),
            _Q(
                'Hindi mo narinig ang sinabi. Ano ang maayos na tugon?',
                ['Maaari po bang pakiulit?', 'Ano ba!', 'Bahala na.'],
                0,
                'Ang mahinahong pakiusap na ulitin ay magalang.'),
          ],
        ),
      ],
    ),
  };

  static final Map<String, List<NorieTopicContent>> _aralingPanlipunan = {
    'g1': _buildPath(
      subject: 'Araling Panlipunan',
      gradeLabel: 'Grade 1',
      accent: 'cyan',
      specs: const [
        _LessonSpec(
          slug: 'ako-at-aking-pagkakakilanlan',
          title: 'Ako at Aking Pagkakakilanlan',
          introduction:
              'Kilalanin ang pangunahing impormasyong naglalarawan sa sarili nang hindi kailangang ibahagi ang pribadong detalye sa ibang tao.',
          keyConcept:
              'May sariling pangalan, katangian, kakayahan, at papel ang bawat bata.',
          points: [
            'Ang pangalan ay tumutukoy sa isang tao.',
            'May mga katangian at kakayahang maaaring magkaiba sa bawat isa.',
            'Mahalagang igalang ang sarili at ang pagkakaiba ng iba.'
          ],
          conceptId: 'ap.g1.pagkakakilanlan',
          conceptLabel: 'Pagkilala sa sarili',
          questions: [
            _Q(
                'Alin ang halimbawa ng impormasyon tungkol sa sarili?',
                [
                  'pangalan',
                  'pangalan ng kalsada ng ibang tao',
                  'lihim ng kaklase',
                  'password'
                ],
                0,
                'Ang pangalan ay pangunahing bahagi ng pagkakakilanlan; hindi kailangang magbahagi ng lihim o password.'),
            _Q(
                'Kung mahusay kang gumuhit, ito ay halimbawa ng...',
                ['kakayahan', 'address', 'patakaran', 'direksiyon'],
                0,
                'Ang pagguhit ay isang kakayahan.'),
            _Q(
                'Ano ang tamang pagtingin sa batang may ibang hilig?',
                [
                  'Igalang siya',
                  'Kutyain siya',
                  'Iwasan siya palagi',
                  'Sabihing mali siya'
                ],
                0,
                'Ang pagkakaiba ng hilig ay dapat igalang.'),
            _Q(
                'Alin ang HINDI dapat ibahagi basta-basta?',
                [
                  'password',
                  'paboritong kulay',
                  'hilig sa pagguhit',
                  'paboritong laro'
                ],
                0,
                'Ang password ay pribadong impormasyon.'),
            _Q(
                'Bakit mahalagang makilala ang sariling kakayahan?',
                [
                  'Upang mapaunlad ito',
                  'Upang maliitin ang iba',
                  'Upang laging makipagpaligsahan',
                  'Upang umiwas sa pag-aaral'
                ],
                0,
                'Ang pagkilala sa kakayahan ay tumutulong upang mapaunlad ito.'),
          ],
          challenges: [
            _Q(
                'Si Aya ay mahilig magbasa at si Ben ay mahilig magtanim. Ano ang tama?',
                [
                  'Parehong maaaring igalang ang kanilang hilig',
                  'Dapat pareho ang hilig nila',
                  'Mali ang isa sa kanila'
                ],
                0,
                'Maaaring magkaiba ang hilig at pareho itong dapat igalang.'),
            _Q(
                'Alin ang ligtas na halimbawa ng pagpapakilala sa klase?',
                [
                  'Ako si Lino at mahilig akong gumuhit.',
                  'Ito ang password ko.',
                  'Ito ang lihim ng kaibigan ko.'
                ],
                0,
                'Ang pangalan at hilig ay sapat na simpleng pagpapakilala; huwag magbahagi ng lihim o password.'),
            _Q(
                'Ang pagkilala sa sariling lakas ay makatutulong upang...',
                ['matuto at umunlad', 'manlait ng iba', 'huwag makinig'],
                0,
                'Nakakatulong ang pagkilala sa lakas upang mapaunlad ang sarili.'),
          ],
        ),
        _LessonSpec(
          slug: 'pamilya-at-tungkulin',
          title: 'Pamilya at Tungkulin',
          introduction:
              'Kilalanin na may iba-ibang anyo ng pamilya at may mga gawaing maaaring pagtulungan sa tahanan.',
          keyConcept:
              'Ang pamilya ay nagtutulungan at nag-aalaga sa isa’t isa sa iba-ibang paraan.',
          points: [
            'Hindi magkakapareho ang ayos ng lahat ng pamilya.',
            'Maaaring magbahagi ng gawaing angkop sa edad.',
            'Ang paggalang at pag-aalaga ay mahalaga sa tahanan.'
          ],
          conceptId: 'ap.g1.pamilya',
          conceptLabel: 'Pamilya at pagtutulungan',
          questions: [
            _Q(
                'Alin ang halimbawa ng pagtutulungan sa bahay?',
                [
                  'pagligpit ng sariling gamit',
                  'pagtatapon ng kalat sa sahig',
                  'pagsigaw sa kasama',
                  'pag-iwan ng gawain sa iba'
                ],
                0,
                'Ang pagligpit ng sariling gamit ay simpleng pagtutulungan.'),
            _Q(
                'Magkakapareho ba ang lahat ng pamilya?',
                [
                  'Hindi',
                  'Oo, laging pareho',
                  'Oo, dapat pareho',
                  'Walang pamilya'
                ],
                0,
                'May iba-ibang anyo at kasapi ang mga pamilya.'),
            _Q(
                'Ano ang mahalaga sa pamilya?',
                ['paggalang', 'pang-aasar', 'paninisi', 'pag-aaway'],
                0,
                'Ang paggalang ay mahalaga sa maayos na samahan.'),
            _Q(
                'Aling gawain ang maaaring angkop sa bata?',
                [
                  'pag-aayos ng laruan',
                  'pagmamaneho ng sasakyan',
                  'pagkukumpuni ng kuryente',
                  'pag-akyat sa bubong'
                ],
                0,
                'Ang pag-aayos ng laruan ay ligtas at angkop na gawaing pambata.'),
            _Q(
                'Kapag may gawain sa bahay, ano ang mabuting gawin?',
                [
                  'Tumulong sa paraang kaya',
                  'Magtago palagi',
                  'Manisi',
                  'Guluhin ang gawain'
                ],
                0,
                'Ang pagtulong sa paraang kaya at ligtas ay mabuting gawain.'),
          ],
          challenges: [
            _Q(
                'May dalawang pamilyang magkaiba ang bilang ng kasapi. Ano ang tama?',
                [
                  'Pareho silang maaaring maging pamilya',
                  'Isa lang ang totoong pamilya',
                  'Dapat magkapareho ang bilang'
                ],
                0,
                'Hindi nasusukat sa iisang ayos o bilang ang pagiging pamilya.'),
            _Q(
                'Natapos mo nang maglaro. Ano ang mabuting gawin?',
                ['Iligpit ang laruan', 'Iwan sa daan', 'Itapon'],
                0,
                'Ang pagligpit ay pananagutan sa sariling gamit.'),
            _Q(
                'May kapamilyang pagod. Ano ang magalang na kilos?',
                [
                  'Mag-alok ng simpleng tulong',
                  'Dagdagan ang kalat',
                  'Asarin siya'
                ],
                0,
                'Ang simpleng tulong ay nagpapakita ng pag-aalaga.'),
          ],
        ),
        _LessonSpec(
          slug: 'paaralan-at-pamayanan',
          title: 'Paaralan at Pamayanan',
          introduction:
              'Kilalanin ang paaralan bilang bahagi ng mas malawak na pamayanan at ang mga taong tumutulong dito.',
          keyConcept:
              'Ang pamayanan ay binubuo ng mga tao at lugar na magkakaugnay sa pang-araw-araw na buhay.',
          points: [
            'Ang paaralan ay isang lugar sa pamayanan.',
            'May iba-ibang taong nagbibigay-serbisyo.',
            'Ang maayos na pakikitungo ay mahalaga sa mga pampublikong lugar.'
          ],
          conceptId: 'ap.g1.pamayanan',
          conceptLabel: 'Paaralan at pamayanan',
          questions: [
            _Q(
                'Alin ang bahagi ng pamayanan?',
                [
                  'paaralan',
                  'isang lihim na password',
                  'isang sagot sa pagsusulit',
                  'isang panaginip'
                ],
                0,
                'Ang paaralan ay pisikal na lugar na bahagi ng pamayanan.'),
            _Q(
                'Sino ang tumutulong sa pag-aaral sa paaralan?',
                ['guro', 'traffic light', 'mesa', 'aklat'],
                0,
                'Ang guro ay taong tumutulong sa pag-aaral.'),
            _Q(
                'Ano ang mabuting asal sa pampublikong lugar?',
                [
                  'sumunod sa patakaran',
                  'manira ng gamit',
                  'magkalat',
                  'mangharang'
                ],
                0,
                'Ang pagsunod sa patakaran ay nakatutulong sa kaayusan.'),
            _Q(
                'Ang barangay health center ay halimbawa ng...',
                [
                  'serbisyo sa pamayanan',
                  'laruan',
                  'pribadong password',
                  'pandiwa'
                ],
                0,
                'Ang health center ay serbisyong makikita sa ilang pamayanan.'),
            _Q(
                'Bakit mahalaga ang mga taong nagbibigay-serbisyo?',
                [
                  'Tumutulong sila sa pangangailangan ng pamayanan',
                  'Para laging may paligsahan',
                  'Para walang patakaran',
                  'Para magkalat'
                ],
                0,
                'Nagbibigay sila ng mahalagang tulong at serbisyo.'),
          ],
          challenges: [
            _Q(
                'Saan ka maaaring pumunta upang mag-aral?',
                ['paaralan', 'intersection', 'garahe ng iba'],
                0,
                'Ang paaralan ay lugar para sa pag-aaral.'),
            _Q(
                'Ano ang pagkakatulad ng paaralan at health center?',
                [
                  'Parehong maaaring bahagi ng pamayanan',
                  'Parehong laruan',
                  'Parehong pribadong bahay'
                ],
                0,
                'Pareho silang maaaring serbisyong lugar sa pamayanan.'),
            _Q(
                'Kung may pila sa isang serbisyo, ano ang maayos na gawin?',
                ['Maghintay ng turno', 'Sumingit', 'Manulak'],
                0,
                'Ang paghihintay ng turno ay paggalang sa iba.'),
          ],
        ),
        _LessonSpec(
          slug: 'mga-lugar-sa-pamayanan',
          title: 'Mga Lugar sa Pamayanan',
          introduction:
              'Iugnay ang karaniwang lugar sa pamayanan sa pangunahing gamit o serbisyong ibinibigay nito.',
          keyConcept:
              'May iba-ibang lugar sa pamayanan na tumutugon sa iba-ibang pangangailangan.',
          points: [
            'Sa paaralan nag-aaral ang mga mag-aaral.',
            'Sa pamilihan nakakabili ng ilang pangangailangan.',
            'Sa health center maaaring humingi ng pangunahing serbisyong pangkalusugan.'
          ],
          conceptId: 'ap.g1.lugar',
          conceptLabel: 'Mga lugar at gamit sa pamayanan',
          questions: [
            _Q(
                'Saan karaniwang nag-aaral ang mga bata?',
                ['paaralan', 'palengke', 'terminal', 'tulay'],
                0,
                'Ang paaralan ang lugar para sa pormal na pag-aaral.'),
            _Q(
                'Saan maaaring bumili ng pagkain at iba pang produkto?',
                ['pamilihan', 'silid-aralan', 'playground', 'aklatan'],
                0,
                'Ang pamilihan ay lugar para sa pagbili at pagbebenta.'),
            _Q(
                'Aling lugar ang kaugnay ng pangunahing serbisyong pangkalusugan?',
                [
                  'health center',
                  'basketball court',
                  'tindahan ng laruan',
                  'paradahan'
                ],
                0,
                'Ang health center ay serbisyong pangkalusugan.'),
            _Q(
                'Saan maaaring humiram o magbasa ng aklat kung may ganitong pasilidad?',
                ['aklatan', 'kalsada', 'garahe', 'palengke'],
                0,
                'Ang aklatan ay lugar para sa mga aklat at pagbasa.'),
            _Q(
                'Bakit dapat pangalagaan ang mga pampublikong lugar?',
                [
                  'Ginagamit ito ng maraming tao',
                  'Para masira agad',
                  'Para walang makinabang',
                  'Para laging sarado'
                ],
                0,
                'Maraming tao ang nakikinabang sa mga pampublikong lugar.'),
          ],
          challenges: [
            _Q(
                'Kailangan mo ng aklat para sa proyekto. Aling lugar ang pinakamalapit na tugma?',
                ['aklatan', 'terminal', 'palengke'],
                0,
                'Ang aklatan ay lugar na kaugnay ng aklat at pagbasa.'),
            _Q(
                'May kailangang pangunahing payong pangkalusugan. Saan maaaring magtanong?',
                ['health center', 'playground', 'tulay'],
                0,
                'Ang health center ay angkop na serbisyong pangkalusugan.'),
            _Q(
                'Alin ang lugar para sa pag-aaral?',
                ['paaralan', 'palengke', 'terminal'],
                0,
                'Ang paaralan ay nakalaan para sa pag-aaral.'),
          ],
        ),
        _LessonSpec(
          slug: 'simpleng-mapa-at-direksiyon',
          title: 'Simpleng Mapa at Direksiyon',
          introduction:
              'Basahin ang payak na mapa gamit ang simbolo, palatandaan, at mga salitang kaliwa, kanan, malapit, at malayo.',
          keyConcept:
              'Ang mapa ay payak na representasyon ng lugar at tumutulong sa paghahanap ng lokasyon at direksiyon.',
          points: [
            'Ang simbolo ay maaaring kumatawan sa isang lugar.',
            'Ang kaliwa at kanan ay tumutulong sa paglalarawan ng posisyon.',
            'Ang palatandaan ay tumutulong sa pagkilala ng lokasyon.'
          ],
          conceptId: 'ap.g1.mapa',
          conceptLabel: 'Pagbasa ng simpleng mapa',
          questions: [
            _Q(
                'Ano ang gamit ng mapa?',
                [
                  'ipakita ang lokasyon ng mga lugar',
                  'magbigay ng password',
                  'palitan ang pangalan ng tao',
                  'magsulat ng tula'
                ],
                0,
                'Ipinapakita ng mapa ang ayos at lokasyon ng mga lugar.'),
            _Q(
                'Ano ang maaaring kumatawan sa paaralan sa mapa?',
                ['simbolo', 'password', 'pang-uri lamang', 'tunog lamang'],
                0,
                'Gumagamit ang mapa ng mga simbolo para sa mga lugar.'),
            _Q(
                'Kung nasa kanan ng bahay ang tindahan, saan ito?',
                ['sa kanan', 'sa kaliwa', 'sa ilalim ng papel', 'wala sa mapa'],
                0,
                'Direktang sinasabi ng pahayag na nasa kanan ang tindahan.'),
            _Q(
                'Ano ang palatandaan?',
                [
                  'bagay o lugar na madaling makilala',
                  'lihim na code',
                  'pangalan ng password',
                  'sagot sa lahat ng tanong'
                ],
                0,
                'Ang palatandaan ay madaling makilalang lugar o bagay na tumutulong sa paghanap ng lokasyon.'),
            _Q(
                'Bakit mahalaga ang legend o susi ng mapa?',
                [
                  'ipinaliliwanag nito ang mga simbolo',
                  'ginagawang lihim ang mapa',
                  'binabago ang direksiyon',
                  'tinatanggal ang mga lugar'
                ],
                0,
                'Ang susi o legend ay nagpapaliwanag sa kahulugan ng mga simbolo.'),
          ],
          challenges: [
            _Q(
                'Ang paaralan ay nasa kaliwa ng parke. Nasaan ang parke mula sa paaralan?',
                ['sa kanan', 'sa kaliwa', 'sa loob ng paaralan'],
                0,
                'Kung nasa kaliwa ng parke ang paaralan, nasa kanan naman ng paaralan ang parke.'),
            _Q(
                'Ano ang unang titingnan kung hindi mo alam ang kahulugan ng simbolo?',
                ['legend o susi', 'pamagat ng ibang aklat', 'password'],
                0,
                'Ipinaliliwanag ng legend ang mga simbolo.'),
            _Q(
                'Alin ang makatutulong bilang palatandaan?',
                [
                  'malaking paaralan sa kanto',
                  'isang lihim na numero',
                  'password ng Wi-Fi'
                ],
                0,
                'Ang malinaw na nakikitang lugar ay maaaring palatandaan.'),
          ],
        ),
        _LessonSpec(
          slug: 'mga-patakaran-at-pananagutan',
          title: 'Mga Patakaran at Pananagutan',
          introduction:
              'Unawain kung bakit may payak na patakaran sa bahay, paaralan, at pamayanan at kung paano ito nakatutulong sa kaligtasan at kaayusan.',
          keyConcept:
              'Ang mabuting patakaran ay tumutulong sa kaligtasan, paggalang, at maayos na pagsasama.',
          points: [
            'May patakaran upang gabayan ang ligtas at maayos na kilos.',
            'May pananagutang sumunod sa angkop na patakaran.',
            'Maaaring humingi ng paliwanag kung hindi nauunawaan ang patakaran.'
          ],
          conceptId: 'ap.g1.patakaran',
          conceptLabel: 'Patakaran at pananagutan',
          questions: [
            _Q(
                'Bakit may patakaran sa silid-aralan?',
                [
                  'upang makatulong sa kaayusan at kaligtasan',
                  'upang walang matuto',
                  'upang laging may parusa',
                  'upang walang magsalita kailanman'
                ],
                0,
                'Ang patakaran ay gabay sa maayos at ligtas na samahan.'),
            _Q(
                'Ano ang dapat gawin sa basurahan?',
                [
                  'itapon doon ang angkop na basura',
                  'iwan ang basura sa sahig',
                  'sirain ito',
                  'itago ang basura sa mesa'
                ],
                0,
                'Ang wastong pagtatapon ay bahagi ng pananagutan sa kalinisan.'),
            _Q(
                'Kapag tatawid sa kalsada, alin ang mahalaga?',
                [
                  'sumunod sa ligtas na tawiran at gabay ng nakatatanda',
                  'tumakbo agad kahit saan',
                  'maglaro sa gitna',
                  'pumikit habang tumatawid'
                ],
                0,
                'Ang ligtas na tawiran at gabay ng nakatatanda ay mahalaga sa bata.'),
            _Q(
                'Kung hindi mo naiintindihan ang patakaran, ano ang mabuting gawin?',
                [
                  'Magtanong nang maayos',
                  'Balewalain agad',
                  'Sirain ang gamit',
                  'Manulak'
                ],
                0,
                'Maaaring humingi ng malinaw na paliwanag sa maayos na paraan.'),
            _Q(
                'Alin ang pananagutan ng mag-aaral?',
                [
                  'alagaan ang sariling gamit at sumunod sa ligtas na tuntunin',
                  'manira ng upuan',
                  'mang-agaw ng gamit',
                  'magkalat'
                ],
                0,
                'Ang pag-aalaga sa gamit at pagsunod sa ligtas na tuntunin ay pananagutan.'),
          ],
          challenges: [
            _Q(
                'May pila sa pagkuha ng gamit. Ano ang wastong kilos?',
                ['Maghintay ng turno', 'Sumingit', 'Manulak'],
                0,
                'Ang paghihintay ng turno ay sumusunod sa kaayusan.'),
            _Q(
                'May basang sahig na may babala. Ano ang dapat gawin?',
                [
                  'Mag-ingat at sundin ang babala',
                  'Tumakbo rito',
                  'Tanggalin ang babala'
                ],
                0,
                'Ang pagsunod sa babala ay nakatutulong sa kaligtasan.'),
            _Q(
                'Bakit may tuntunin sa playground?',
                [
                  'Upang maging mas ligtas ang paggamit',
                  'Upang walang makapaglaro',
                  'Upang masira ang kagamitan'
                ],
                0,
                'Ang mga tuntunin ay tumutulong sa ligtas na paggamit ng lugar.'),
          ],
        ),
        _LessonSpec(
          slug: 'paggalang-sa-pagkakaiba',
          title: 'Paggalang sa Pagkakaiba',
          introduction:
              'Kilalanin na maaaring magkaiba ang wika, hilig, kakayahan, tradisyon, at karanasan ng mga tao at dapat silang tratuhin nang may dignidad.',
          keyConcept:
              'Ang pagkakaiba ay hindi dahilan para mangutya, magbukod, o mang-api.',
          points: [
            'Maaaring magkaiba ang tao sa maraming paraan.',
            'Mahalaga ang magalang na salita at kilos.',
            'Maaaring matuto mula sa karanasan at pananaw ng iba.'
          ],
          conceptId: 'ap.g1.pagkakaiba',
          conceptLabel: 'Paggalang sa pagkakaiba',
          questions: [
            _Q(
                'May kaklaseng gumagamit ng ibang wika sa bahay. Ano ang tama?',
                [
                  'Igalang siya',
                  'Kutyain siya',
                  'Iwasan siya',
                  'Sabihing mali ang pamilya niya'
                ],
                0,
                'Ang pagkakaiba ng wika ay dapat igalang.'),
            _Q(
                'May batang mas mabagal tumakbo. Ano ang mabuting kilos?',
                [
                  'Huwag siyang kutyain',
                  'Tawanan siya',
                  'Itulak siya',
                  'Huwag siyang isali kailanman'
                ],
                0,
                'Ang kakayahan ng bawat tao ay maaaring magkaiba at dapat igalang.'),
            _Q(
                'Ano ang maaaring matutuhan sa pagkakaiba?',
                [
                  'Bagong pananaw at karanasan',
                  'Na may taong mas mababa',
                  'Na dapat pare-pareho lahat',
                  'Na hindi dapat makinig'
                ],
                0,
                'Ang pagkakaiba ay maaaring magbigay ng bagong kaalaman at pananaw.'),
            _Q(
                'Alin ang magalang na salita?',
                [
                  'Maaari mo bang ipaliwanag ang tradisyong iyan?',
                  'Ang weird mo.',
                  'Mali kayo.',
                  'Ayoko sa inyo.'
                ],
                0,
                'Ang maayos na pagtatanong ay nagpapakita ng paggalang.'),
            _Q(
                'Ano ang dapat gawin kapag may nakikitang pangungutya?',
                [
                  'Humingi ng tulong sa mapagkakatiwalaang nakatatanda',
                  'Sumali sa pangungutya',
                  'I-video para pagtawanan',
                  'Ikalat pa'
                ],
                0,
                'Ang paghingi ng tulong sa mapagkakatiwalaang nakatatanda ay ligtas at makatutulong.'),
          ],
          challenges: [
            _Q(
                'Magkaiba ang paboritong pagkain nina Ina at Jo. Ano ang tama?',
                [
                  'Parehong maaaring igalang ang kanilang gusto',
                  'Dapat magkapareho sila',
                  'Dapat pagtawanan ang isa'
                ],
                0,
                'Hindi kailangang pareho ang gusto upang magkaroon ng paggalang.'),
            _Q(
                'May bagong kaklaseng iba ang tradisyon. Ano ang magandang unang hakbang?',
                ['Maging magalang at makinig', 'Husgahan agad', 'Kutyain'],
                0,
                'Ang paggalang at pakikinig ay mabuting paraan ng pakikitungo.'),
            _Q(
                'Alin ang nagpapakita ng pagsasama at paggalang?',
                [
                  'Isama ang iba sa ligtas at angkop na gawain',
                  'Laging magbukod',
                  'Mang-asar'
                ],
                0,
                'Ang pagsasama at paggalang ay tumutulong sa mabuting samahan.'),
          ],
        ),
      ],
    ),
  };

  static const _teaching = <String,
      ({
    String objective,
    List<String> worked,
    List<String> guided,
    String mistake,
    String diagram
  })>{
    'alpabeto-at-tunog': (
      objective:
          'Maiugnay ang malaking at maliit na titik sa unang tunog ng salita.',
      worked: [
        'Sabihin ang bola nang dahan-dahan: /b/ /o/ /l/ /a/.',
        'Ang unang tunog ay /b/. Ang titik B o b ang kumakatawan dito.',
        'Sa mesa, /m/ ang unang tunog. Kaya M o m ang unang titik.'
      ],
      guided: [
        'Sabihin ang lapis. Ano ang unang tunog?',
        'Bigkasin ang /l/. Piliin ang L, hindi B.',
        'Subukan ang tasa: /t/ ang simula, kaya T.'
      ],
      mistake:
          'Hindi tunog ang nakasulat na titik. Nakikita ang B; naririnig ang /b/ kapag binibigkas ang bola.',
      diagram:
          'Titik -> unang tunog -> salita\nB / b -> /b/ -> bola\nM / m -> /m/ -> mesa\nT / t -> /t/ -> tasa'
    ),
    'pantig-at-payak-na-salita': (
      objective:
          'Mahati ang payak na salita sa pantig at mabilang ang mga ito.',
      worked: [
        'Bigkasin ang bata: ba-ta.',
        'Pumalakpak sa ba at sa ta. Dalawang palakpak, dalawang pantig.',
        'Sa kamatis: ka-ma-tis. Tatlong bagsak ng tinig, tatlong pantig.'
      ],
      guided: [
        'Bigkasin ang lapis nang dahan-dahan.',
        'Hatiin: la-pis. Ilang pantig? Dalawa.',
        'Subukan ang gatas: ga-tas, dalawang pantig.'
      ],
      mistake:
          'Hindi bilang ng titik ang bilang ng pantig. May apat na titik ang bata ngunit dalawang pantig: ba-ta.',
      diagram:
          'bata -> [ba] + [ta] -> 2 pantig\nmesa -> [me] + [sa] -> 2 pantig\nkamatis -> [ka] + [ma] + [tis] -> 3 pantig'
    ),
    'pangngalan': (
      objective:
          'Matukoy ang ngalan ng tao, hayop, bagay, at lugar sa pangungusap.',
      worked: [
        'Basahin: Si Ana ay may aso sa bahay.',
        'Ana ang ngalan ng tao. Aso ang ngalan ng hayop.',
        'Bahay ang ngalan ng lugar. Lahat ng tatlong ito ay pangngalan.'
      ],
      guided: [
        'Basahin: May lapis ang guro.',
        'Sino ang tao? Guro. Ano ang bagay? Lapis.',
        'Guro at lapis ang pangngalan; hindi ang may o ang.'
      ],
      mistake:
          'Ang sumulat ay kilos, hindi ngalan ng tao o bagay. Ang guro ang tao; ang sumulat ang ginawa niya.',
      diagram:
          'Pangngalan\nTao -> Ana, guro\nHayop -> aso, pusa\nBagay -> lapis, libro\nLugar -> bahay, paaralan'
    ),
    'pandiwa': (
      objective:
          'Matukoy ang salitang nagsasaad ng kilos sa payak na pangungusap.',
      worked: [
        'Basahin: Nagbasa si Mia ng libro.',
        'Itanong: Ano ang ginawa ni Mia? Nagbasa.',
        'Nagbasa ang pandiwa. Mia ang tao at libro ang bagay.'
      ],
      guided: [
        'Basahin: Tumalon ang bata.',
        'Ano ang ginawa? Tumalon. Ito ang pandiwa.',
        'Sa Kumanta si Ben, kumanta ang pandiwa.'
      ],
      mistake:
          'Hindi kilos ang bata o mesa. Hanapin ang ginagawa: tumalon, sumulat, o kumain.',
      diagram:
          'Sino? -> Ano ang ginawa?\nMia -> nagbasa\nBen -> kumanta\naso -> tumakbo'
    ),
    'pang-uri': (
      objective:
          'Matukoy ang salitang naglalarawan sa kulay, laki, o katangian ng pangngalan.',
      worked: [
        'Basahin: pulang bola.',
        'Bola ang bagay. Pula ang kulay na naglalarawan sa bola.',
        'Sa maliit na pusa, maliit ang naglalarawan ng laki ng pusa.'
      ],
      guided: [
        'Basahin: malamig na yelo.',
        'Yelo ang bagay. Ano ang katangian nito? Malamig.',
        'Sa matamis na mangga, matamis ang pang-uri.'
      ],
      mistake:
          'Ang kumain ay kilos, hindi katangian. Sa matamis na mangga, mangga ang bagay at matamis ang paglalarawan.',
      diagram:
          'Pang-uri -> Pangngalan\npula -> bola\nmaliit -> pusa\nmalamig -> yelo'
    ),
    'payak-na-pangungusap': (
      objective:
          'Makabuo ng pangungusap na buo ang diwa at may malaking titik at wastong bantas.',
      worked: [
        'Ayusin ang mga salita: si / Ana / ay / nagbabasa.',
        'Sabihin kung sino at ano ang ginagawa: Si Ana ay nagbabasa.',
        'Gamitin ang malaking S sa simula at tuldok sa dulo.'
      ],
      guided: [
        'Basahin: ang aso. Alam natin ang hayop ngunit wala pang sinasabi tungkol dito.',
        'Idagdag ang kilos: Tumakbo ang aso.',
        'Tanong naman ang Nasaan ang aso? Kaya tandang pananong ang nasa dulo.'
      ],
      mistake:
          'Hindi sapat ang malaking titik at tuldok kung kulang ang diwa. Ang Aso. ay isang salita; ang Tumakbo ang aso. ay buo ang sinasabi.',
      diagram:
          'Sino? + Ano ang ginagawa? -> Buong pangungusap\nSi Ana + ay nagbabasa -> Si Ana ay nagbabasa.\nTanong -> Nasaan ang aklat?'
    ),
    'pag-unawa-sa-maikling-kuwento': (
      objective:
          'Matukoy ang tauhan, tagpuan, at pagkakasunod-sunod ng pangyayari sa maikling kuwento.',
      worked: [
        'Basahin: Nagtanim si Liza ng buto sa bakuran. Diniligan niya ito. Pagkaraan ng ilang araw, may tumubong halaman.',
        'Sino? Liza ang tauhan. Saan? Sa bakuran ang tagpuan.',
        'Ano ang nauna? Nagtanim. Sumunod ang pagdidilig; saka tumubo ang halaman.'
      ],
      guided: [
        'Balikan ang kuwento ni Liza. Saan siya nagtanim?',
        'Hanapin ang salitang bakuran. Ito ang lugar na nasa kuwento.',
        'Ano ang nangyari pagkatapos magtanim? Diniligan niya ang buto.'
      ],
      mistake:
          'Huwag sabihing sa paaralan nagtanim si Liza. Bakuran ang nakasaad sa kuwento; hindi dapat magdagdag ng ibang lugar.',
      diagram:
          'Liza (tauhan) -> bakuran (tagpuan)\n1. Nagtanim -> 2. Nagdilig -> 3. Tumubo ang halaman'
    ),
    'magalang-na-pakikipag-usap': (
      objective:
          'Makagamit ng angkop na magalang na pakiusap, pasasalamat, at tugon.',
      worked: [
        'Nais humiram ni Mia ng lapis sa guro.',
        'Maaari po bang humiram ng lapis? ang malinaw at magalang na pakiusap.',
        'Kapag naibalik ang lapis, sasabihin niyang Salamat po sa pagpapahiram.'
      ],
      guided: [
        'Nais mong dumaan ngunit may tao sa daan. Ano ang sasabihin?',
        'Makikiraan po. Maghintay na makadaan nang maayos.',
        'Kung hindi narinig ang guro, sabihin: Maaari po bang pakiulit?'
      ],
      mistake:
          'Hindi palaging oo ang magalang na sagot. Maaari kang magsabi ng Hindi po, salamat nang mahinahon kung ayaw mo.',
      diagram:
          'Humihiram -> Maaari po bang humiram?\nMay tumulong -> Salamat po.\nHindi narinig -> Maaari po bang pakiulit?'
    ),
    'ako-at-aking-pagkakakilanlan': (
      objective:
          'Mailarawan ang sarili gamit ang pangalan, hilig, at kakayahan nang hindi ibinabahagi ang lihim.',
      worked: [
        'Nagpakilala si Lino: Ako si Lino. Mahilig akong gumuhit.',
        'Lino ang pangalan; pagguhit ang kanyang hilig at maaaring kakayahan.',
        'Hindi niya kailangang sabihin ang password o lihim upang makilala siya ng klase.'
      ],
      guided: [
        'Si Aya ay mahilig magbasa. Alin ang hilig niya?',
        'Pagbabasa ang hilig ni Aya; Aya ang pangalan.',
        'Maaari mong ilarawan ang paboritong kulay o laro sa halip na magbahagi ng lihim.'
      ],
      mistake:
          'Magkaiba ang hilig at kakayahan. Maaari kang mahilig sa pagguhit habang patuloy mo pa itong natututuhan.',
      diagram:
          'Ako\nPangalan -> Lino\nHilig -> pagguhit\nKakayahang sinasanay -> paggawa ng larawan\nPribado -> password (huwag ibahagi)'
    ),
    'pamilya-at-tungkulin': (
      objective:
          'Makilala ang pagtutulungan sa iba-ibang pamilya at pumili ng ligtas na gawaing angkop sa bata.',
      worked: [
        'Kasama ni Ana ang lola sa bahay. Pamilya rin sila kahit magkaiba sa pamilya ng kaklase.',
        'Pagkatapos maglaro, inililigpit ni Ana ang laruan. Tungkulin niya ang pag-aalaga ng sariling gamit.',
        'Ang lola ang humahawak ng mainit na kalan. Humihingi ng tulong si Ana sa gawaing delikado.'
      ],
      guided: [
        'Tapos ka nang magbasa. Ano ang maaari mong gawin?',
        'Ibalik ang aklat sa lalagyan. Ligtas itong pagtulong.',
        'Kung may sirang saksakan, ipaalam sa nakatatanda; huwag itong ayusin.'
      ],
      mistake:
          'Hindi kailangang pareho ang bilang o kasapi ng lahat ng pamilya. Pag-aalaga at pagtutulungan ang mahalaga.',
      diagram:
          'Gawain -> Angkop na tumulong\nIligpit ang laruan -> bata\nIbalik ang aklat -> bata\nAyusin ang kuryente -> bihasang nakatatanda'
    ),
    'paaralan-at-pamayanan': (
      objective:
          'Makilala ang paaralan at mga taong nagbibigay ng serbisyo bilang bahagi ng pamayanan.',
      worked: [
        'Sa pamayanan ni Ben ay may paaralan at health center.',
        'Ang guro ay tumutulong sa pag-aaral sa paaralan.',
        'Ang nars ay tumutulong sa pangangalaga ng kalusugan sa health center. Magkaiba ang serbisyo nila.'
      ],
      guided: [
        'Kailangan ni Mia ng tulong sa pagbasa. Sino ang maaaring tumulong sa paaralan?',
        'Guro ang tumutulong sa pag-aaral.',
        'Kung may pila sa pagkuha ng aklat, maghintay ng turno upang makagamit ang lahat.'
      ],
      mistake:
          'Lugar ang paaralan; tao ang guro. Hindi pareho ang lugar at taong nagbibigay ng serbisyo rito.',
      diagram:
          'Pamayanan\nPaaralan -> guro -> pag-aaral\nHealth center -> nars -> pangangalaga ng kalusugan\nPamilihan -> tindero -> pagbili ng produkto'
    ),
    'mga-lugar-sa-pamayanan': (
      objective:
          'Maiugnay ang karaniwang lugar sa pamayanan sa gamit o serbisyong kailangan.',
      worked: [
        'Kailangan ng pamilya ni Aya ng gulay. Sa pamilihan sila bibili.',
        'Kailangan ni Aya ng aklat na mahihiram. Sa aklatan siya magtatanong kung may ganitong pasilidad.',
        'Kailangan ng pangunahing serbisyong pangkalusugan. Kasama ang nakatatanda, maaaring pumunta sa health center.'
      ],
      guided: [
        'Nais mong mag-aral sa klase. Aling lugar ang angkop?',
        'Paaralan ang lugar ng klase, hindi terminal.',
        'Nais mong magbasa ng hiniram na aklat. Aklatan ang tugma sa pangangailangan.'
      ],
      mistake:
          'Hindi magkakapareho ang serbisyo ng mga lugar. Sa pamilihan bumibili; sa paaralan nag-aaral.',
      diagram:
          'Pangangailangan -> Lugar\nPag-aaral -> paaralan\nPagkain -> pamilihan\nAklat -> aklatan\nKalusugan -> health center'
    ),
    'simpleng-mapa-at-direksiyon': (
      objective:
          'Magamit ang susi ng mapa at kaliwa/kanan upang mahanap ang lugar sa payak na mapa.',
      worked: [
        'Tingnan ang mapa sa Larawang gabay. Nasa kaliwa ang P at nasa kanan ang T.',
        'Sa susi, P ang paaralan at T ang tindahan. B ang bahay sa gitna.',
        'Mula sa bahay, nasa kaliwa ang paaralan at nasa kanan ang tindahan. Ito ang kaliwa at kanan habang nakatingin sa mapa.'
      ],
      guided: [
        'Mula sa paaralan, saan ang bahay sa mapa?',
        'Nasa kanan ng P ang B. Kaya nasa kanan ng paaralan ang bahay.',
        'Kung hindi alam ang kahulugan ng T, basahin ang susi: tindahan.'
      ],
      mistake:
          'Huwag hulaan ang simbolo. Basahin muna ang susi. Ang kaliwa at kanan dito ay ayon sa nakikita sa papel, hindi sa direksiyong nakaharap ang ibang tao.',
      diagram:
          'Payak na mapa (nakatingin sa papel)\nKALIWA <--- [P] --- [B] --- [T] ---> KANAN\nSusi: P = paaralan; B = bahay; T = tindahan\nP at B ay magkatabi; may B sa pagitan ng P at T.'
    ),
    'mga-patakaran-at-pananagutan': (
      objective:
          'Maipaliwanag ang gamit ng ligtas na patakaran at maisagawa ang simpleng pananagutan.',
      worked: [
        'May basang sahig at babala sa silid. Maaaring madulas ang tatakbo rito.',
        'Dahan-dahang dumaan sa ligtas na lugar at sabihin sa guro kung may panganib.',
        'May dahilan ang babala: pag-iwas sa pagkadulas. Ito ang ugnayan ng patakaran at kaligtasan.'
      ],
      guided: [
        'May pila sa pagkuha ng gamit. Ano ang dapat gawin?',
        'Maghintay ng turno. Lahat ay magkakaroon ng pagkakataon.',
        'Kung hindi malinaw ang tuntunin, magtanong sa guro nang maayos.'
      ],
      mistake:
          'Hindi lahat ng utos ay ligtas. Kung may ipinagagawang nakasasakit o nakatatakot, humingi ng tulong sa mapagkakatiwalaang nakatatanda.',
      diagram:
          'Sitwasyon -> Ligtas na kilos -> Dahilan\nBasang sahig -> mag-ingat -> iwas dulas\nMay pila -> maghintay -> patas ang pagkakataon\nMay kalat -> gumamit ng basurahan -> malinis na lugar'
    ),
    'paggalang-sa-pagkakaiba': (
      objective:
          'Makilala ang pagkakaiba ng hilig, wika, at kakayahan at makapili ng magalang na kilos.',
      worked: [
        'Ibang wika ang gamit ni Jo sa bahay. Filipino naman ang gamit ni Ina.',
        'Maaaring magkaiba ang wika at pareho silang makasali sa klase.',
        'Magtanong nang maayos at makinig kung nais malaman ang salita ni Jo.'
      ],
      guided: [
        'Mahilig magbasa si Aya; mahilig magtanim si Ben. Kailangan bang pareho ang hilig?',
        'Hindi. Igalang ang pareho at pakinggan ang kanilang kuwento.',
        'Kung may pangungutya, humingi ng tulong sa mapagkakatiwalaang nakatatanda.'
      ],
      mistake:
          'Ang pagkakaiba ng wika o kakayahan ay hindi nangangahulugang mas mababa ang isang bata. Huwag magbukod dahil lamang sa pagkakaiba.',
      diagram:
          'Magkaibang hilig\nAya -> pagbasa\nBen -> pagtatanim\nPareho -> paggalang, pakikinig, pagkakataong makasali'
    ),
  };

  static const List<String> supportedSubjects = [
    'Filipino',
    'Araling Panlipunan',
  ];

  static List<NorieTopicContent> topicsFor(String subject, String gradeId) {
    final source = switch (subject.toLowerCase()) {
      'filipino' => _filipino,
      'araling panlipunan' => _aralingPanlipunan,
      _ => const <String, List<NorieTopicContent>>{},
    };
    return List.unmodifiable(source[gradeId] ?? const <NorieTopicContent>[]);
  }

  static Set<String> gradeIdsFor(String subject) {
    return switch (subject.toLowerCase()) {
      'filipino' => _filipino.keys.toSet(),
      'araling panlipunan' => _aralingPanlipunan.keys.toSet(),
      _ => const <String>{},
    };
  }

  static Iterable<NorieTopicContent> get allTopics sync* {
    for (final grade in _filipino.values) {
      yield* grade;
    }
    for (final grade in _aralingPanlipunan.values) {
      yield* grade;
    }
  }

  static List<NorieTopicContent> _buildPath({
    required String subject,
    required String gradeLabel,
    required String accent,
    required List<_LessonSpec> specs,
  }) {
    return List.unmodifiable([
      for (var i = 0; i < specs.length; i++)
        _topic(
          subject: subject,
          gradeId: 'g1',
          gradeLabel: gradeLabel,
          accent: accent,
          order: i + 1,
          previousSlug: i == 0 ? null : specs[i - 1].slug,
          spec: specs[i],
        ),
    ]);
  }

  static NorieTopicContent _topic({
    required String subject,
    required String gradeId,
    required String gradeLabel,
    required String accent,
    required int order,
    required String? previousSlug,
    required _LessonSpec spec,
  }) {
    final subjectSlug = subject.toLowerCase().replaceAll(' ', '-');
    final id = '$subjectSlug.$gradeId.${spec.slug}';
    final teaching = _teaching[spec.slug]!;
    List<NorieQuestionContent> convert(List<_Q> source, String kind) {
      return List.generate(source.length, (i) {
        final question = source[i];
        final correctIndex = i % question.options.length;
        final shift =
            (question.correctIndex - correctIndex + question.options.length) %
                question.options.length;
        final options = List.generate(
            question.options.length,
            (index) =>
                question.options[(index + shift) % question.options.length]);
        return NorieQuestionContent(
          id: '$id-$kind${i + 1}',
          prompt: question.prompt,
          options: options,
          correctIndex: correctIndex,
          explanation: question.explanation,
          difficulty: kind == 'c' ? 'advanced' : 'foundation',
          conceptId: spec.conceptId,
          conceptLabel: spec.conceptLabel,
        );
      });
    }

    return NorieTopicContent(
      id: id,
      subject: subject,
      category: gradeLabel,
      gradeLevel: gradeId,
      title: spec.title,
      subtitle: 'Authored $gradeLabel lesson',
      order: order,
      accent: accent,
      prerequisiteTopicId:
          previousSlug == null ? null : '$subjectSlug.$gradeId.$previousSlug',
      lesson: NorieLessonContent(
        heading: spec.title,
        introduction: spec.introduction,
        sections: [
          NorieLessonSection(
              title: 'Layunin',
              symbol: '1',
              accent: accent,
              points: [teaching.objective]),
          NorieLessonSection(
              title: 'Tuklasin',
              symbol: '2',
              accent: accent,
              points: spec.points),
          NorieLessonSection(
              title: 'Larawang gabay',
              symbol: '3',
              accent: accent,
              body: teaching.diagram,
              points: const []),
          NorieLessonSection(
              title: 'Halimbawang may paliwanag',
              symbol: '4',
              accent: 'cyan',
              points: teaching.worked),
          NorieLessonSection(
              title: 'Subukan natin',
              symbol: '5',
              accent: 'orange',
              points: teaching.guided),
          NorieLessonSection(
              title: 'Karaniwang pagkakamali',
              symbol: '!',
              accent: 'magenta',
              points: [teaching.mistake]),
          NorieLessonSection(
              title: 'Balikan',
              symbol: '7',
              accent: 'green',
              points: [spec.keyConcept]),
        ],
        keyConceptTitle: 'Tandaan',
        keyConceptBody: spec.keyConcept,
      ),
      quiz: NorieQuizContent(questions: convert(spec.questions, 'q')),
      challenge: NorieChallengeContent(
        title: '${spec.title} Challenge',
        description: 'Gamitin ang natutuhan sa tatlong bagong sitwasyon.',
        rounds: convert(spec.challenges, 'c'),
      ),
    );
  }
}

class _LessonSpec {
  const _LessonSpec({
    required this.slug,
    required this.title,
    required this.introduction,
    required this.keyConcept,
    required this.points,
    required this.conceptId,
    required this.conceptLabel,
    required this.questions,
    required this.challenges,
  });

  final String slug;
  final String title;
  final String introduction;
  final String keyConcept;
  final List<String> points;
  final String conceptId;
  final String conceptLabel;
  final List<_Q> questions;
  final List<_Q> challenges;
}

class _Q {
  const _Q(this.prompt, this.options, this.correctIndex, this.explanation);
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �Y �]Ys�:�g�
j^��xߺ��F���6�`��R��ml����t�N'�߾���:IȲ�t�sđp�C����hLC�˧ �A�dqEiyx��G�BQ�D� (���9�y�m���Z��&�w���r���C�>���I7	���ho��*��q��)� *���������@�X�B�H%�2�f�/ީ.�?JT%�2p������+���p��	�������?��&J�W���'���K�5|�����t5��{�r��N�O�����$t��;�ԞG��E���{-�����4B�����yNٔK�(M�(M�Iظ�E����OS$����Q����O�7�g��
?G�?��xQ�������s��RF����� '6d�&�B�z�lC��E�)M��(�2��I}a,0���G	�;e�ւ6U�	�U���I�ϯ}�`!���h�	Z��Աbc���#��s=$(��!
�ܤu�'����p:�IH��$�L�	kW�ˋ#Y�E�[��Җ(z5�����tj��
/=���ѿ)~i���r�r�d�s��r��¨j��|���2���ױ�|p�W�?J��S�O ��/�?/�,�|�6o5�,�M���A&s �5e%����!ǳ�Jܵ���\�'�Y��i�q����k�`jZC�Z��(J~#�D�S�&��p�s�dl�P�S�W�&meq|��!9�G��9����'��6̅;g㣸��B��b�Mn1�z���+1�C�Aɔ�z�ŌF�!�i�A=ާe� v0?�`����#Сs͡��Չ�X,�����^���9�53ϛrw)m-lq�0�U�����L�N�"��$̓��V���Nip�3m�P<Q(tz�S(@d���*.	����c����G�v#f����+6F�T��G~�A�ڀ��,c%�U.܍PޕV�e��(jugJ7u-j6:r����=!98��B���N}���=/���kp+O<��p `�v!r�r�,��t�2	m�&Fv���	��J=2�6H�\�j�D�i��&C.J !P�/k<y:>���D�	t#.b�f)u4������-��ۙr�IҒ�hb�x>��C&�!f�ɱhDsfы��(�e��F��=3��/��t�������ۊ�����Q�S�U�G��?�t��e�5�g9�;�;�ׁzd�5�{���Ǜ�D=q��%���|�!q���^B�Џ��
|Hʐ�zGE󫂩�d�i9���2s��I��G�:��2��4]� �l��b�p����Y.&�ne8�5�5�!���Y������|��,�{�̢��A�晘Y��N�]�����{�Х��Soz�.��Ti�LOT�Z�@n��ð�@
Zoi�rf�m qY�����+ d��TɌ�L�@����C� ���o䠛��>�u�^��[��kSR�F�D�����d:��u\6�.��̶��	�4���Q/%�E�l����ņ�熂�`~�n3�'0 ���臙\���p=E�̺9�8�7!����S���w�7�����!�*��|����y���P��?�>*����+��ϵ~A��9&�r��=B���2�K�������+U�O�����):�I#������8E���!h��Ew�e
���E� W�8�^��w������(��"���+����88�;���p�����Ҏg	}.�@���p����6����̈ɸ!�MS�wL��V-eX��C����c�}��t�Y�̱�1G[+|���i�,�F1�+ٞ�U��{�K��3����R�Q�������e�Z�������j��]��3�*�/$�G��S���m�?�{���
_
�G(L��6.@s^����`�����Fߛ5(�>��.to;M�w��q���G&]���xR�M��5�{&h�G����ޡ��ct�$an�:�9^o�e�����5���@S�(Z��|��t�A��u;�,�=Ѻ��-��٠�H*�{�����Y�i�f�%�S�q�3 ��l(bK Ӑ���3'��ۼ��k�2	]X�7h�y��磅iϞ�P���I`*�e��w{�χf}yX@�I�F�M���^��Ҳ��h�����j"8���cq)e#���K�HȜ'pr�5CZ�?�����g��������g��T�_
*����+��ϵެ�]��G�]��(�V�_
.��+4�".�������KA���W��������R�m�S�*��\��c��;���`h@��C0���xκ��9�3,���0��(͒$eWQ~�ʐ���H�]�%���?�	�"�^�U��csbkL̶��s�u����ؓ��b�J }'̢N�VjhH�h��D�*�G�	�6v�f씶����#Bݞ���%@<Z���&#���9�d�~?���ލ��?J<?��#�/��Q��������=���c�����.����eJ�r��]��R�^�?H�}��r�\�4�c����G������GQ���[
~��G�������2�)�:w�Y�X�ql�t�b)��(�s	��l<!p�u<�Y�	ǷY���j��4�!���p�8��Z��|\���Et|KD�X�Ř���6�,�3�)��D�l����z@.�j�uw�9��+>��z"�F����L8�u~�zͥ|�G�|F�D��Nc�;����&���k��3[��ލ���/m}��GP��W
~�%���U��^���O���/��P&ʐ�+�J�O㿉�'��2�Z�W�������?w��Z�����k,a	�0������G��,	��3����=�J���.�j�s���]��� �7�ݰ����s��Mk?lڹe�@��S�����b�?�]h�i���Mb�ڷ�me1l#ע�IZ_����15��D�Xo�Ql��:G����h�(�74cLw�(c=�H�p[�G�d#�Gz�I��9|��I,̸���@8ǻ5u�\��S�&���t�*�)�sj�N%��ǆD��0����@ u�3"�]o˥Y����A�Ě@�D0�ljN�����|�@�����:[i�f��JyJX;;���C� �y��L:AO�$������������E�/��4����>R�����?�W�)�-���٫����3��[��%ʐ�������JV翗����������6���{��4r����X~���{C��<3���#� ����} �'�@���-��) ��i����1~r��@���M�u7!�C$�PI����H{�.�}�VzjB��=�[3�c7҄�!�JgL�:M���Tfx@A7��W㸯ƍ�΃����� ��>t�����dͲAs��R����y��t���V���R��S2���k�g�`�r���[�߃N�Ѱ	#$�D��������H���q���MV��෰��g�������Z�����g��������|T������_���Q������ê�.���r��b�Ǩ�_���T�_���.���?�|�����Rp9�a�4��LM1E����>�Q$�8�N�8��(��S��庘�0^��[���b�������J����2%[����95#����ͩ����.Y#[j�5yq��1X�騭��+�{��z����p�ʍ(�9����Q����-���3�(C�ez��RGYl�C�j��{�E��O�����Կ>,���4��O�!P����R��4��_kaAP�'���_�Z͵��R�M�v��M��,|/̧c`;�Խr��{����+��F��E<�O��W�i���js��V��I��e��7ͮ"~�����֫�~r�`%��{����Z���)-�K{�}���ڕ[��i�B���U�r]�VӅ_{��O�C���q�h�.��NΫ]9������q�W��;u�.Zl���>��/9���[�⶿W{�򓛕��G�k��U�nm�ۑ��]�+���Ec���.�7Quй��}CT� �b���>�{�tq��}E4�]�[!�׊Jr�#��Q�=�ɢ(	���G�v��}��]t�~O�u��߼ZZ���-X����bF�����g���[��eҜH��m��7�����i]��Wv7�~Z���<���ϫ��g￟�آ����@.*�=,��SS�(�OW�7M���(��aۛ	�&.N7��s���L�GR��j�h�\"�"D~��j��Ծ���}�w��o�pD�=u���)��P��H1�]]��@V�� ވ#��!+bw`|c�qYU�6���l*��z]Y5�mW��W�'Q��wv'�|���Ӈ��ɞ���|j��Yy�]�zq���o~*�HK��o�jc]'�8\.��s�r(A.��.�/]׽t�H׭�N�m������u��n�i�NLPb��/Ac�&A#�DL����Q�(�@B�Q���m��g;���9.��M����>/��Ͽ����A�!bWHO%�	2I���bx0�/�If2�ԥd:㺵-��TGOR�@d�����x��}3-�Y�.-`�@��l^���<<��M�9���0�ɇm�wTeI�{:884��6�����D�8�����[f&M7�.��8Z|ۀ��"&Y2b��h�n�ڨ�;VIp�><ά��w(IPz;��Lv�C�-d�4E����K��v��;ĻY�3�h}0�׌�����҈y$DfUJ��)�2l����Y#~��y�-��!c�Q��U�.���8ˋ�)�M�6�.�-�.�i8E��K3�pj�����7�������NF~0��|D��uru�N�_T$v �r�UY���`.�u���=f�Tk5�.s�렚N�B�A7��SIG�x��~��������=�Re�EXs�7#�ˈ�H���׌���we>�W��k�ZS�"��n�9H3���E��ں���]d��SyV��R�6y����U�.r�\�lQ�I�Z;[3��\sB�VWn�3Bs2��#���\���3�:�dT[PN�+�b��9��잴�*���$͛6�sR�u�B��x���X��u��e���ۜ�i��m���tx��Kǧھ��0W����ꪽ$�������B�V/dy��>G���L���W��j:��>��Q�qѹ�@�{��'��{��w������Qc����?��������?�+q�(���8��������k-����6Ru�]W5�?$�Xdۋ��~?�ƶ�,�X�g�W���Q�U�G8�rzF9�I�{����~�3����[���x�7�/?��K���s�+x���n<AA?s�kƁp�N��;؍�C/޹�s�*���sз�AO�����������}z��}O��)���7�׳�y`D��{Q�K�Y�G�c=:��%�I�f�0�V���D��� C�w~�����2]�b���f��#��!xv�e��l�(�ϐn7�/D�����
m�Y@�����50_����N��4�/�(�����I;'���h�d���ћ9��-X
�D�mt�;��(L)�U8��D���,��1%:���E�`��ޚE!�Ig}%��L��JeO����(!�(�E���T�%Ą�g�RPR����URU�b�|�x���R��[/�(<˥��}�ӧl&�̈́����0a��D�퐁�Ծ���SGXkSOpHt�No������\	Y��!&8�Mהlč��x2�IJ�m"�]��q�kq��W6Q&���$*���FO�5�#���	�ن;�OH$@�p�J2��F��̴� H�ڑ��<|�C�=�3�c`sȊw"�09@���"B`��:hY!��b�X�GH�i�XM��0����J���=�.WM7�:���� E3|~��컍滯,�cR�%��(˖;���H�,��N�d0�݉���P@����׊���1�f�V�ʇ�b�%6�`!N�.���E�\YTAs�:����D絢DE�p!UM�>&�gZRjNY���.U����C�bM��$�u��*�r �a��D�r��7iGLe�Ŝw'����T�d��GrM����I�/��\U!p�U��"e�/P����R_AY�h��3�oU�<J�n?�%41t'��Pk���+i�oᅡ��0�D���N��V�U6��vPw�I4��p��5)6��^T�e��F��+�)s2�,{�gd�*ڄ�C���X�֧��*�to��{E�A����fn:��C� ~�!�;>"�ך*�&���S�{�b$��r$ܞd��`�S����>�����m����D�5���U�tn�JhZ�N�O�]�q�n�U����3���eo�ʳ��γ~�tQi�������uA�͉F�]�k��n���Y"w�3�ʛ��R�T��MЍ���x��K�(q�Np1�)�y���̯�6U����·���(<��'5Y�-'�֬M�6䡛��k`�ᇟC�>���j��ꜳЙ�� 0��~� n�<+�*f͡[��u�k��1u?��,�q´��).���ypW�/F>sz2+f�z�@t�'ʪ��L���Y ��f$}�Q��Y����GnE^�^��Z����{?���~)X�������Ik�A�EJ=S�b� ȷ��-�Vvn�A���ԑiK�E��Ѡa.:J�p�����,88q4�Q��
���t��"�{����H��p�CS�R�R�_$����(X��]�	�#�--���V����� �y�DP��#[L)��u�6Y��W�Ջ�`��=�*�F�`�@P��)0ZLP��	
i�?���4n�=jb8D,K�$S��CD��x&:����z+1�h��#�F��`�/���;��"]��+CoKAEg���8W�^�|�|cs�hC���T/&[��ER��GP]�6�� LR��r8+70}\�i�^:�����6�8l�8��u�zIwC��N�-S��i�;&�9&>ӊ9˳��C�u*���i+î�;��zX��������}Y<,;������:�d��#l��$�rW�$�c^v��)�����,fPy���8V��3A�IL5(2�E��5eY���0�pyg0aԦ��Ĕ�CdP#����Ʃ-W a�;J��)1-�(L ��%�FH�ܞ.��ax0���p���*&����`��X8l0d7B��yd�]"5����Q�wP��䐨+Q��W���y���bYl�#�����^)U���,���e��F�0�"teK.��w��aMLlI8�st�%y�\/�"�N7��j�)컴���m�q��ǡ��l�o%��}h�l&�
���Br+��6.�[Ͱ]�m�QVk-!�V;\����µ���S���&^������k7��g����y�>�).	���	A�8���n���+���sqT�J��8	�����܋�bv���o��j�pǧ��o������K/���?]k�]�{�^���c�X8Q���8���z���������r ���g����Ko��� �x���M|󦿾��W�? z�$��8x*�~p�ڕޯ��䊞n��h:Q�m@g߈��O~�/6~'����_/��׿�'��)�����4E�|�	�9K�|զv��N��i�l��M����߿��i; mS;mj�M��}6�g{?P;ͷ��|�� U�B����z��&�&�A�-"�N21����L��1��=��_��^��&��<ۭ�y��T�S��3���6���gp��X���`9_�MM�Y�i�sf�h�=gƞ`O�����a�e�3s���G�s9f�\8�0�!Bk��6�]��1�9��_ju��b��>��>��>޷��̹�  
clc;
clear all;
close all;

fid = fopen("textbox_loop.txt","w");

fprintf(fid,"///////////////////////////\n");

for k=1:20

    fprintf(fid, '<tr>                                                                   \n');
    fprintf(fid, '  <td>Port_0%d</td>                                                     \n',k);
    fprintf(fid, '  <td> <input type = "text" id = "Port_0%d_text" /> </td>               \n',k);
    fprintf(fid, '  <td>                                                                 \n');
    fprintf(fid, '    <select id = "Port_0%d_dropdown_type">                              \n',k);
    fprintf(fid, '        <option value = "std_logic" selected>std_logic</option>        \n');
    fprintf(fid, '        <option value = "std_logic_vector">std_logic_vector</option>   \n');
    fprintf(fid, '    </select>                                                          \n');
    fprintf(fid, '   </td>                                                               \n');
    fprintf(fid, '  <td> <input type = "text" id = "Port_0%d_from_text" size="1"/> </td>  \n',k);
    fprintf(fid, '  <td> downto </td>                                                    \n');
    fprintf(fid, '  <td> <input type = "text" id = "Port_0%d_to_text"  size="1"/> </td>   \n',k);
    fprintf(fid, '  <td> way </td>                                                       \n');
    fprintf(fid, '  <td>                                                                 \n');
    fprintf(fid, '    <select id = "Port_0%d_dropdown_way">                               \n',k);
    fprintf(fid, '        <option value = "IN" selected>IN</option>                      \n');
    fprintf(fid, '        <option value = "OUT">OUT</option>                             \n');
    fprintf(fid, '    </select>                                                          \n');
    fprintf(fid, '  </td>                                                                \n');
    fprintf(fid, '  <td> used </td>                                                      \n');
    fprintf(fid, '  <td> <input type = "checkbox" id = "Port_0%d_used" value = "on"> </td>\n',k);
    fprintf(fid, '</tr>                                                                  \n');
    fprintf(fid,'\n\n\n');
  
end;

for k=1:8

    fprintf(fid, '<tr>                                                                   \n');
    fprintf(fid, '  <td>Generic_param_0%d</td>                                                     \n',k);
    fprintf(fid, '  <td> <input type = "text" id = "Generic_param_0%d_text" /> </td>               \n',k);
    fprintf(fid, '  <td>                                                                 \n');
    fprintf(fid, '    <select id = "Generic_param_0%d_dropdown_type">                              \n',k);
    fprintf(fid, '        <option value = "integer" selected>integer</option>   \n');
    fprintf(fid, '        <option value = "boolean" selected>boolean</option>   \n');
    fprintf(fid, '    </select>                                                          \n');
    fprintf(fid, '   </td>                                                               \n');
    fprintf(fid, '  <td> value </td>                                                      \n');
    fprintf(fid, '  <td> <input type = "text" id = "Generic_param_0%d_from_text" size="1"/> </td>  \n',k);
    fprintf(fid, '  <td> used </td>                                                      \n');
    fprintf(fid, '  <td> <input type = "checkbox" id = "Generic_param_0%d_used" value = "on"> </td>\n',k);
    fprintf(fid, '</tr>                                                                  \n');
    fprintf(fid,'\n\n\n');
  
end;

fprintf(fid,"///////////////////////////\n");

fclose(fid);
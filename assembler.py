
import re
def remove_comments_and_spaces(line):
    # Remove anything after '#' and leading/trailing spaces
    cleaned_line = line.split('#')[0].strip()

    # Remove extra spaces between tokens
    return cleaned_line


def to_binary(decimal_number, width=16):
    n = int(decimal_number)
    if n >= 0:
        binary = bin(n)[2:]
        return binary.zfill(width)
    else:
        binary = bin(n & (2 ** width - 1))[2:]
        return binary.zfill(width)
    
def hex_to_decimal(hex_string):
    decimal_value = int(hex_string, 16)
    return decimal_value

def no_operand_check(instruction):
    if len(instruction)==1:
        return True
    else: 
        return False
    
def one_operand_check(instruction):
     if len(instruction)==2 and len(instruction[1])==2 and instruction[1][0]=='r' and 0 <= int(instruction[1][1]) <= 7:
        return True
     else: 
        return False
def two_operand_check(instruction):
     if len(instruction)==3 and len(instruction[1])==2 and instruction[1][0]=='r' and len(instruction[2])==2  and instruction[2][0]=='r' and 0 <= int(instruction[1][1]) <= 7 and 0 <= int(instruction[2][1]) <= 7 :
        return True
     else: 
        return False
def bitset_one_operand_check(instruction): 
     if len(instruction)==3 and len(instruction[1])==2 and instruction[1][0]=='r' and 0 <= int(instruction[1][1]) <= 7 and 0<=int(instruction[2])<=31  :
        return True
     else: 
        return False
def imm_one_operand_check(instruction):
     if len(instruction)==3 and len(instruction[1])==2 and instruction[1][0]=='r' and 0 <= int(instruction[1][1]) <= 7 and 0 <= hex_to_decimal(instruction[2]) <= 65535 :
        return True
     else: 
        return False

def three_operand_check(instruction):
     if len(instruction)==4 and len(instruction[1])==2 and len(instruction[2])==2 and len(instruction[3])==2 and instruction[1][0]=='r' and instruction[2][0]=='r' and instruction[3][0]=='r' and 0 <= int(instruction[1][1]) <= 7 and 0 <= int(instruction[2][1]) <= 7 and 0 <= int(instruction[3][1]) <= 7:
        return True
     else: 
        return False
     
def Imm3_operand_check(instruction): 
     if len(instruction)==4 and len(instruction[1])==2 and len(instruction[2])==2 and 0 <= hex_to_decimal(instruction[3]) <= 65535 and instruction[1][0]=='r' and instruction[2][0]=='r' and 0 <= int(instruction[1][1]) <= 7 and 0 <= int(instruction[2][1]) <= 7:
        return True
     else: 
        return False
def EA_one_operand_check(instruction):
     if len(instruction)==3 and len(instruction[1])==2 and instruction[1][0]=='r' and 0 <= int(instruction[1][1]) <= 7 and 0 <= hex_to_decimal(instruction[2]) <= 1048575 :
        return True
     else: 
        return False

file_path = 'program.txt'
with open(file_path, 'r') as file:
    instructions = []
    for line in file:
        cleaned_line=remove_comments_and_spaces(line)
        words = [word.lower() for word in re.split(r'[,\s]+', line.split('#')[0].strip())]
        if  words[0]==".org" : 
            print(words)
            print(int(words[1],16))
            for i in range(int(words[1],16)):
                instructions.append(['nop'])
        elif (len(words)==1 or len(words)==2) and cleaned_line.count(',')==0: #no operand/one operand
            if words[0]!="":
                instructions.append(words)
        elif len(words)==3 and cleaned_line.count(',')==1: #two operand
            if words[0]!="":
                instructions.append(words)
        elif len(words)==4 and cleaned_line.count(',')==2: #two operand
            if words[0]!="":
                instructions.append(words)
        else:
            print("error in instruction "+ cleaned_line+" syntax")

# # Print the 2D array
for instruction in instructions:
    print(instruction)
binary_codes = []
for instruction in instructions:
    if instruction[0]=="nop":
        if no_operand_check(instruction):
            binary_codes.append("0000000000000000")
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="not":
        if one_operand_check(instruction):
            binary_instruction="000001"
            reg=to_binary(instruction[1][1],3)
            binary_instruction=binary_instruction+reg+reg+"0000"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="neg":
        if one_operand_check(instruction):
            binary_instruction="000010"
            reg=to_binary(instruction[1][1],3)
            binary_instruction=binary_instruction+reg+reg+"0000"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="inc":
        if one_operand_check(instruction):
            binary_instruction="000011"
            reg=to_binary(instruction[1][1],3)
            binary_instruction=binary_instruction+reg+reg+"0000"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="dec":
        if one_operand_check(instruction):
            binary_instruction="000100"
            reg=to_binary(instruction[1][1],3)
            binary_instruction=binary_instruction+reg+reg+"0000"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="out":
        if one_operand_check(instruction):
            binary_instruction="000101"
            reg=to_binary(instruction[1][1],3)
            binary_instruction=binary_instruction+reg+reg+"0000"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="in":
        if one_operand_check(instruction):
            binary_instruction="000110"
            reg=to_binary(instruction[1][1],3)
            binary_instruction=binary_instruction+reg+reg+reg+'0'
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="swap":
        if two_operand_check(instruction):
            binary_instruction="010000"
            reg1=to_binary(instruction[1][1],3)
            reg2=to_binary(instruction[2][1],3)
            binary_instruction=binary_instruction+reg2+reg1+reg2+"0"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")

    elif instruction[0]=="add":
        if three_operand_check(instruction):
            binary_instruction="010001"
            reg1=to_binary(instruction[1][1],3)
            reg2=to_binary(instruction[2][1],3)
            reg3=to_binary(instruction[3][1],3)
            binary_instruction=binary_instruction+reg1+reg2+reg3+"0"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="addi":
        if Imm3_operand_check(instruction):
            binary_instruction="010010" 
            reg1=to_binary(instruction[1][1],3)
            reg2=to_binary(instruction[2][1],3)
            Imm=hex_to_decimal(instruction[3])
            Imm=to_binary(str(Imm),16)
            binary_instruction=binary_instruction+reg1+reg2+"0000"
            binary_codes.append(binary_instruction)
            binary_codes.append(Imm)
        else: 
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="sub":
       if three_operand_check(instruction):
           binary_instruction="010011"
           reg1=to_binary(instruction[1][1],3)
           reg2=to_binary(instruction[2][1],3)
           reg3=to_binary(instruction[3][1],3)
           binary_instruction=binary_instruction+reg1+reg2+reg3+"0"
           binary_codes.append(binary_instruction)
       else:
           instruction_string = ' '.join(instruction)
           print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="and":
       if three_operand_check(instruction):
           binary_instruction="010100"
           reg1=to_binary(instruction[1][1],3)
           reg2=to_binary(instruction[2][1],3)
           reg3=to_binary(instruction[3][1],3)
           binary_instruction=binary_instruction+reg1+reg2+reg3+"0"
           binary_codes.append(binary_instruction)
       else:
           instruction_string = ' '.join(instruction)
           print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="or":
       if three_operand_check(instruction):
           binary_instruction="010101"
           reg1=to_binary(instruction[1][1],3)
           reg2=to_binary(instruction[2][1],3)
           reg3=to_binary(instruction[3][1],3)
           binary_instruction=binary_instruction+reg1+reg2+reg3+"0"
           binary_codes.append(binary_instruction)
       else:
           instruction_string = ' '.join(instruction)
           print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="xor":
       if three_operand_check(instruction):
           binary_instruction="010110"
           reg1=to_binary(instruction[1][1],3)
           reg2=to_binary(instruction[2][1],3)
           reg3=to_binary(instruction[3][1],3)
           binary_instruction=binary_instruction+reg1+reg2+reg3+"0"
           binary_codes.append(binary_instruction)
       else:
           instruction_string = ' '.join(instruction)
           print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="cmp":
       if two_operand_check(instruction):
           binary_instruction="010111"
           reg1=to_binary(instruction[1][1],3)
           reg2=to_binary(instruction[2][1],3)
           binary_instruction=binary_instruction+reg1+reg1+reg2+"0"
           binary_codes.append(binary_instruction)
       else:
           instruction_string = ' '.join(instruction)
           print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="bitset":
       if bitset_one_operand_check(instruction):
           binary_instruction="011000"
           reg1=to_binary(instruction[1][1],3)
           imm=hex_to_decimal(instruction[2])
           imm=to_binary(str(imm),16)
           binary_instruction=binary_instruction+reg1+reg1+"0000"
           binary_codes.append(binary_instruction)
           binary_codes.append(imm)
       else:
           instruction_string = ' '.join(instruction)
           print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="rcl":
       if imm_one_operand_check(instruction):
           binary_instruction="011001"
           reg1=to_binary(instruction[1][1],3)
           imm=hex_to_decimal(instruction[2])
           imm=to_binary(str(imm),16)
           binary_instruction=binary_instruction+reg1+reg1+"0000"
           binary_codes.append(binary_instruction)
           binary_codes.append(imm)
       else:
           instruction_string = ' '.join(instruction)
           print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="rcr":
       if imm_one_operand_check(instruction):
           binary_instruction="011010"
           reg1=to_binary(instruction[1][1],3)
           imm=hex_to_decimal(instruction[2])
           imm=to_binary(str(imm),16)
           binary_instruction=binary_instruction+reg1+reg1+"0000"
           binary_codes.append(binary_instruction)
           binary_codes.append(imm)
       else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="push":
       if one_operand_check(instruction):
           binary_instruction="100000"
           reg1=to_binary(instruction[1][1],3)
           binary_instruction=binary_instruction+reg1+reg1+"0000"
           binary_codes.append(binary_instruction)
       else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="pop":
       if one_operand_check(instruction):
           binary_instruction="100001"
           reg1=to_binary(instruction[1][1],3)
           binary_instruction=binary_instruction+reg1+"0000000"
           binary_codes.append(binary_instruction)
       else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="ldm": #LDM Rdst, Imm
       if imm_one_operand_check(instruction):
            binary_instruction="100010"
            reg1=to_binary(instruction[1][1],3)
            imm=hex_to_decimal(instruction[2])
            imm=to_binary(str(imm),16)
            binary_instruction=binary_instruction+reg1+"0000000"
            binary_codes.append(binary_instruction)
            binary_codes.append(imm)
       else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="ldd":
       if EA_one_operand_check(instruction):
            binary_instruction="100011"
            reg1=to_binary(instruction[1][1],3)
            EA=hex_to_decimal(instruction[2])
            EA=to_binary(str(EA),20)
            binary_instruction=binary_instruction+reg1+"000"+EA[0:4]
            binary_codes.append(binary_instruction)
            binary_codes.append(EA[4:20])
       else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="std":
       if EA_one_operand_check(instruction):
            binary_instruction="100100"
            reg1=to_binary(instruction[1][1],3)
            EA=hex_to_decimal(instruction[2])
            EA=to_binary(str(EA),20)
            binary_instruction=binary_instruction+reg1+reg1+EA[0:4]
            binary_codes.append(binary_instruction)
            binary_codes.append(EA[4:20])
       else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="protect":
       if one_operand_check(instruction):
            binary_instruction="100101"
            reg1=to_binary(instruction[1][1],3)
            binary_instruction=binary_instruction+reg1+reg1+"0000"
            binary_codes.append(binary_instruction)
       else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="free":
        if one_operand_check(instruction):
            binary_instruction="100110"
            reg1=to_binary(instruction[1][1],3)
            binary_instruction=binary_instruction+reg1+reg1+"0000"
            binary_codes.append(binary_instruction)
        else:
           instruction_string = ' '.join(instruction)
           print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="jz":
        if one_operand_check(instruction):
            binary_instruction="110000"
            reg=to_binary(instruction[1][1],3)
            binary_instruction=binary_instruction+reg+reg+"0000"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="jmp":
        if one_operand_check(instruction):
            binary_instruction="110001"
            reg=to_binary(instruction[1][1],3)
            binary_instruction=binary_instruction+reg+reg+"0000"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="call":
        if one_operand_check(instruction):
            binary_instruction="110010"
            reg=to_binary(instruction[1][1],3)
            binary_instruction=binary_instruction+reg+reg+"0000"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="ret":
        if no_operand_check(instruction):
            binary_instruction="110011"
            binary_instruction=binary_instruction+"0000000000"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    elif instruction[0]=="rti":
        if no_operand_check(instruction):
            binary_instruction="110100"
            binary_instruction=binary_instruction+"0000000000"
            binary_codes.append(binary_instruction)
        else:
            instruction_string = ' '.join(instruction)
            print("error in instruction "+ instruction_string+" syntax")
    else:
        instruction_string = ' '.join(instruction)
        print("unknown instruction "+ instruction_string)

file_path = 'binary.txt'

with open(file_path, 'w') as file:
    # Write each element of the array to a new line
    file.writelines('\n'.join(binary_codes))





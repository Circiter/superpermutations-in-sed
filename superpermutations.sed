#!/bin/sed -Enf

# Finds a superpermutation for a given alphabet.
# Uses a greedy algorithm, so a generated superpermutation
# is not, in general, a minimum one.

# Hosted at https://github.com/Circiter/superpermutations-in-sed
# Based on permutations.sed (gists.github.com/Circiter/ab4f8538d3882562e38a2e7525acc480

# (c) Written by Circiter (mailto:xcirciter@gmail.com).
# License: MIT.

s/^/@>/

# In the hold space, the @ characters
# divides the list of permutations and
# the emulated call-stack.
x; s/^/@/; x

:permute
    :select_one_position
        # Move a character to the front.
        s/@(.*>)(.)/\2@\1/
        H # Push.
        s/>//

        # As a new permutation becomes
        # available, append it to the
        # hold space (before the stack).
        /@$/ {
            x
            # But it is simpler to copy the last line to the ^.
            s/^(.*\n)([^\n]*)@>$/\2\n\1\2@>/
            x
            breturn
        }

        # Process the tail (@.*$) recursively.
        s/@/@>/; bpermute
        :return

        # If the stack is empty, quit.
        x; /@$/ {s/[\n]*@$//; x; bdone}; x

        # Pop.
        g; s/^.*\n([^\n]*)$/\1/
        x; s/\n[^\n]*$//; x

        s/(.)@(.*)>/@\2\1>/ # Recover the first character's position.
        />./ bselect_one_position
    breturn

:done

# Now the hold space contains all the generated permutations.

# Up to this point, all the code above copied almost verbatim
# from permutations.sed; for the logic related to superpemutations
# see below.

s/^.*$/>/

:build_superpermutation
    s/$/@/
    G
    s/$/\n/

    # Extract the previously matched permutation
    # and remove it from the list of permutations.
    s/>(.*)(@.*\n)\1\n/>\1\2/
    # Then send all the permutations back into the hold space.
    h; x; s/^.*@\n//; s/\n$//; x

    :compare_affixes
        # Select a suffix.
        s/>([^@])/\1>/
        /@\n$/! {
            # And search among the permutations.
            s/>(.*)@.*\n\1([^\n]*)\n/>\1\2@/; tok
        }
        />[^@]/ bcompare_affixes

    # Can not match any affixes.
    bexit

    :ok
    s/@.*$// # Cleanup.
    bbuild_superpermutation

:exit

s/[>@\n]//g
p

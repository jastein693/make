include gmsl/gmsl

two := x x
three := x x x

sieve_size := 1000
sieve_size_encode := $(call int_encode,$(sieve_size))
rawbits := $(call int_halve,$(sieve_size_encode))

factor := $(three)

bit_is_true = $(filter x,$(word $(call int_decode,$(call int_inc,$(call int_halve,$1))),$(rawbits)))

find_factor =	$(if $(call bit_is_true,$(num)),\
					$(eval factor := $(num)),\
					$(eval num += $(two))\
					$(call find_factor)\
				)

clear_bits =	$(if $(call int_gt,$(num),$(sieve_size_encode)),,\
					$(eval half := $(call int_halve,$(num)))\
					$(eval rawbits := $(wordlist 1,$(call int_decode,$(half)),$(rawbits)) f $(wordlist $(call int_decode,$(call int_plus,$(half),$(two))),$(call int_decode,$(rawbits)),$(rawbits)))\
					$(eval num := $(call int_plus,$(num),$(call int_multiply,$(factor),$(two))))\
					$(call clear_bits)\
			  	)

odd_number := x
sub := $(sieve_size_encode)

run_sieve = $(if $(call int_eq,$(sub),),,\
				$(eval sub := $(call int_subtract,$(sub),$(odd_number)))\
				$(eval odd_number += $(two))\
				$(eval num := $(factor))\
				$(call find_factor)\
				$(eval num := $(call int_multiply,$(factor),$(three)))\
				$(call clear_bits)\
				$(eval factor += $(two))\
				$(call run_sieve)\
			)

print_num := $(three)
results := 2
print_results = $(foreach a,$(rawbits),\
					$(or \
						$(and \
							$(if $(call bit_is_true,$(print_num)),\
								$(eval results := $(results), $(call int_decode,$(print_num)))\
							),\
						),\
						$(eval print_num += $(two)),\
					)\
				)

total_primes :=
count_primes =  $(and \
					$(foreach a,$(rawbits),\
						$(if $(filter x,$(a)),\
							$(eval total_primes := $(call int_inc,$(total_primes)))\
						),\
					),\
				)

all: ; @echo $(run_sieve) $(count_primes) total $(call int_decode,$(total_primes))
# all: ; @echo $(run_sieve) $(count_primes) total $(call int_decode,$(total_primes)) $(print_results) $(results)
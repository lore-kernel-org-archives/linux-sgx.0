Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F11C742A7
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 06:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18FF92054F
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 06:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfGMG64 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 02:58:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:30886 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfGMG64 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 02:58:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 23:58:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,485,1557212400"; 
   d="scan'208";a="186748334"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.254.24.170]) ([10.254.24.170])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jul 2019 23:58:55 -0700
Subject: Re: [RFC PATCH v2 1/3] selftests/x86: Fixed Makefile for SGX selftest
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        kai.svahn@intel.com, kai.huang@intel.com
References: <cover.1555965327.git.cedric.xing@intel.com>
 <20190424062623.4345-2-cedric.xing@intel.com>
 <20190712031925.32dqi3v3jetojaju@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <d2feafcb-91e2-292c-d54c-5d2e46c245d7@intel.com>
Date:   Fri, 12 Jul 2019 23:58:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712031925.32dqi3v3jetojaju@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/11/2019 8:19 PM, Jarkko Sakkinen wrote:
> On Tue, Apr 23, 2019 at 11:26:21PM -0700, Cedric Xing wrote:
>> The original x86/sgx/Makefile doesn't work when 'x86/sgx' is specified as the
>> test target. This patch fixes that problem, along with minor changes to the
>> dependencies between 'x86' and 'x86/sgx' in selftests/x86/Makefile.
>>
>> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
>> ---
>>   tools/testing/selftests/x86/Makefile     | 12 +++----
>>   tools/testing/selftests/x86/sgx/Makefile | 45 +++++++++---------------
>>   2 files changed, 22 insertions(+), 35 deletions(-)
>>
>> diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
>> index 4fc9a42f56ea..1294c5f5b6ca 100644
>> --- a/tools/testing/selftests/x86/Makefile
>> +++ b/tools/testing/selftests/x86/Makefile
>> @@ -70,11 +70,11 @@ all_32: $(BINARIES_32)
>>   
>>   all_64: $(BINARIES_64)
>>   
>> -all_64: $(SUBDIRS_64)
>> -	@for DIR in $(SUBDIRS_64); do			\
>> -		BUILD_TARGET=$(OUTPUT)/$$DIR;		\
>> -		mkdir $$BUILD_TARGET  -p;		\
>> -		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;	\
>> +all_64: | $(SUBDIRS_64)
>> +	@for DIR in $|; do					\
>> +		BUILD_TARGET=$(OUTPUT)/$$DIR;			\
>> +		mkdir $$BUILD_TARGET  -p;			\
>> +		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$DIR $@;	\
> 
> This is not fix for anything. It is change in semantics. This diff
> should be isolated to its own commit as you are changing something
> outside of SGX scope.

I have removed all changes to x86/Makefile from v4.

The current x86/Makefile only builds but cannot run sgx selftest. I 
don't see it as an urgent issue though.

>>   	done
>>   
>>   EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
>> @@ -90,7 +90,7 @@ ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)
>>   all: warn_32bit_failure
>>   
>>   warn_32bit_failure:
>> -	@echo "Warning: you seem to have a broken 32-bit build" 2>&1; 	\
>> +	@echo "Warning: you seem to have a broken 32-bit build" 2>&1;	\
> 
> Please clean this up.
> 
>>   	echo "environment.  This will reduce test coverage of 64-bit" 2>&1; \
>>   	echo "kernels.  If you are using a Debian-like distribution," 2>&1; \
>>   	echo "try:"; 2>&1; \
>> diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
>> index 1fd6f2708e81..3af15d7c8644 100644
>> --- a/tools/testing/selftests/x86/sgx/Makefile
>> +++ b/tools/testing/selftests/x86/sgx/Makefile
>> @@ -2,47 +2,34 @@ top_srcdir = ../../../../..
>>   
>>   include ../../lib.mk
>>   
>> -HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC
>> -ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
>> +ifeq ($(shell $(CC) -dumpmachine | cut --delimiter=- -f1),x86_64)
>> +all: all_64
>> +endif
>> +
>> +HOST_CFLAGS := -Wall -Werror -g $(INCLUDES)
>> +ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIE \
>>   	       -fno-stack-protector -mrdrnd $(INCLUDES)
>>   
>>   TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
>>   all_64: $(TEST_CUSTOM_PROGS)
>>   
>> -$(TEST_CUSTOM_PROGS): $(OUTPUT)/main.o $(OUTPUT)/sgx_call.o \
>> -		      $(OUTPUT)/encl_piggy.o
>> +$(TEST_CUSTOM_PROGS): main.c sgx_call.S $(OUTPUT)/encl_piggy.o
>>   	$(CC) $(HOST_CFLAGS) -o $@ $^
>>   
>> -$(OUTPUT)/main.o: main.c
>> -	$(CC) $(HOST_CFLAGS) -c $< -o $@
>> -
>> -$(OUTPUT)/sgx_call.o: sgx_call.S
>> -	$(CC) $(HOST_CFLAGS) -c $< -o $@
>> -
>> -$(OUTPUT)/encl_piggy.o: $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
>> -	$(CC) $(HOST_CFLAGS) -c encl_piggy.S -o $@
>> +$(OUTPUT)/encl_piggy.o: encl_piggy.S $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
>> +	$(CC) $(HOST_CFLAGS) -I$(OUTPUT) -c $< -o $@
>>   
>> -$(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf $(OUTPUT)/sgxsign
>> +$(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf
>>   	objcopy --remove-section=.got.plt -O binary $< $@
>>   
>> -$(OUTPUT)/encl.elf: $(OUTPUT)/encl.o $(OUTPUT)/encl_bootstrap.o
>> -	$(CC) $(ENCL_CFLAGS) -T encl.lds -o $@ $^
>> +$(OUTPUT)/encl.elf: encl.lds encl.c encl_bootstrap.S
>> +	$(CC) $(ENCL_CFLAGS) -T $^ -o $@
>>   
>> -$(OUTPUT)/encl.o: encl.c
>> -	$(CC) $(ENCL_CFLAGS) -c $< -o $@
>> -
>> -$(OUTPUT)/encl_bootstrap.o: encl_bootstrap.S
>> -	$(CC) $(ENCL_CFLAGS) -c $< -o $@
>> -
>> -$(OUTPUT)/encl.ss: $(OUTPUT)/encl.bin  $(OUTPUT)/sgxsign
>> -	$(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
>> +$(OUTPUT)/encl.ss: $(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin
>> +	$^ $@
>>   
>>   $(OUTPUT)/sgxsign: sgxsign.c
>>   	$(CC) -o $@ $< -lcrypto
>>   
>> -EXTRA_CLEAN := $(OUTPUT)/sgx-selftest $(OUTPUT)/sgx-selftest.o \
>> -	       $(OUTPUT)/sgx_call.o $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss \
>> -	       $(OUTPUT)/encl.elf $(OUTPUT)/encl.o $(OUTPUT)/encl_bootstrap.o \
>> -	       $(OUTPUT)/sgxsign
>> -
>> -.PHONY: clean
>> +EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(addprefix $(OUTPUT)/,	\
>> +		encl.elf encl.bin encl.ss encl_piggy.o sgxsign)
>> -- 
>> 2.17.1
>>
> 
> What are all these changes to the makefile? I don't see mention of them
> in the commit message.

Added description to the commit message in v4.

> /Jarkko
> 

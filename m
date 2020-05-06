Return-Path: <SRS0=a91O=6U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5DCC28CBC
	for <linux-sgx@archiver.kernel.org>; Wed,  6 May 2020 16:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2B6A20708
	for <linux-sgx@archiver.kernel.org>; Wed,  6 May 2020 16:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="bzxrwsOd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgEFQj5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 May 2020 12:39:57 -0400
Received: from linux.microsoft.com ([13.77.154.182]:57468 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729443AbgEFQj5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 6 May 2020 12:39:57 -0400
Received: from [192.168.1.17] (unknown [76.104.235.235])
        by linux.microsoft.com (Postfix) with ESMTPSA id EABA020B717B;
        Wed,  6 May 2020 09:39:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EABA020B717B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1588783196;
        bh=DYwcgcDMGuEgCCUUtRb92BG6ZazFViO8KjmvF3kSQmw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bzxrwsOdKFr/jqO/ArVI0YFE1SMjNnLdo4Ko7BOVTwB0k2KW2DBIvC2iK8fsm4Dta
         MPl7B9onL3dVzu3i2r0TZ85khYPx7ni3jqn8chnvhidanX9K6DxB/F0hpkgp02JsQt
         WQS7okicH0etFuShGeyve/eUGHBWfsAmJQDVP7CI=
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
From:   Jordan Hand <jorhand@linux.microsoft.com>
Message-ID: <e50f4c00-12e6-19e6-ead3-f180074bceea@linux.microsoft.com>
Date:   Wed, 6 May 2020 09:39:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/21/20 2:52 PM, Jarkko Sakkinen wrote:
> Intel(R) SGX is a set of CPU instructions that can be used by applications
> to set aside private regions of code and data. The code outside the enclave
> is disallowed to access the memory inside the enclave by the CPU access
> control.
> 
> There is a new hardware unit in the processor called Memory Encryption
> Engine (MEE) starting from the Skylake microacrhitecture. BIOS can define
> one or many MEE regions that can hold enclave data by configuring them with
> PRMRR registers.
> 
> The MEE automatically encrypts the data leaving the processor package to
> the MEE regions. The data is encrypted using a random key whose life-time
> is exactly one power cycle.
> 
> The current implementation requires that the firmware sets
> IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
> decide what enclaves it wants run. The implementation does not create
> any bottlenecks to support read-only MSRs later on.
> 
> You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
> 
> 	cat /proc/cpuinfo  | grep sgx
> 
> v29:
> * The selftest has been moved to selftests/sgx. Because SGX is an execution
>    environment of its own, it really isn't a great fit with more "standard"
>    x86 tests.
> 
>    The RSA key is now generated on fly and the whole signing process has
>    been made as part of the enclave loader instead of signing the enclave
>    during the compilation time.
> 
>    Finally, the enclave loader loads now the test enclave directly from its
>    ELF file, which means that ELF file does not need to be coverted as raw
>    binary during the build process.
> * Version the mm_list instead of using on synchronize_mm() when adding new
>    entries. We hold the write lock for the mm_struct, and dup_mm() can thus
>    deadlock with the page reclaimer, which could hold the lock for the old
>    mm_struct.
> * Disallow mmap(PROT_NONE) from /dev/sgx. Any mapping (e.g. anonymous) can
>    be used to reserve the address range. Now /dev/sgx supports only opaque
>    mappings to the (initialized) enclave data.
> * Make the vDSO callable directly from C by preserving RBX and taking leaf
>    from RCX.
> 

Tested with the Open Enclave SDK on top of Intel PSW. Specifically built 
the Intel PSW with changes to support /dev/sgx mapping[1] new in v29.

Tested-by: Jordan Hand <jorhand@linux.microsoft.com>

[1] https://github.com/intel/linux-sgx/pull/530

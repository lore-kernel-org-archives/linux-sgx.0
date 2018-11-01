Return-Path: <SRS0=LYKh=NM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD8FC0044C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 19:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BAE6205F4
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 19:00:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BAE6205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbeKBEFF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:05:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:29446 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbeKBEFF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Nov 2018 00:05:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Nov 2018 12:00:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,453,1534834800"; 
   d="scan'208";a="277588429"
Received: from btyborox-mobl.ger.corp.intel.com ([10.249.254.138])
  by fmsmga006.fm.intel.com with ESMTP; 01 Nov 2018 12:00:40 -0700
Date:   Thu, 1 Nov 2018 21:00:38 +0200 (EET)
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
X-X-Sender: jsakkine@jsakkine-mobl1
To:     Florian Weimer <fweimer@redhat.com>
cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linux API <linux-api@vger.kernel.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rich Felker <dalias@libc.org>, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Adhemerval Zanella <adhemerval.zanella@linaro.org>,
        carlos@redhat.com
Subject: Re: RFC: userspace exception fixups
In-Reply-To: <877ehwisaa.fsf@oldenburg.str.redhat.com>
Message-ID: <alpine.DEB.2.21.1811012058480.7972@jsakkine-mobl1>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com> <877ehwisaa.fsf@oldenburg.str.redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181101190038.YaBl7SiZfPB91nQcJ07l9m8Hto64W2oqCOpJ73akvY8@z>

On Thu, 1 Nov 2018, Florian Weimer wrote:
> * Andy Lutomirski:
>
>> The basic idea would be to allow libc, or maybe even any library, to
>> register a handler that gets a chance to act on an exception caused by
>> a user instruction before a signal is delivered.  As a straw-man
>> example for how this could work, there could be a new syscall:
>>
>> long register_exception_handler(void (*handler)(int, siginfo_t *, void *));
>>
>> If a handler is registered, then, if a synchronous exception happens
>> (page fault, etc), the kernel would set up an exception frame as usual
>> but, rather than checking for signal handlers, it would just call the
>> registered handler.  That handler is expected to either handle the
>> exception entirely on its own or to call one of two new syscalls to
>> ask for normal signal delivery or to ask to retry the faulting
>> instruction.
>
> Would the exception handler be a per-thread resource?

For SGX purposes it would *need* to be per-thread resource so that the
run-time (not just Intel but any user space support code for SGX) is
able to act on thread that caused this exception inside the enclave.

/Jarkko

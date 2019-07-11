Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A59A4C742A2
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 22:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79537208E4
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 22:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfGKWMm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 18:12:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:42207 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbfGKWMl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 18:12:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 15:12:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="168760918"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga003.jf.intel.com with ESMTP; 11 Jul 2019 15:12:39 -0700
Subject: Re: [PATCH v20 22/28] x86/traps: Attempt to fixup exceptions in vDSO
 before signaling
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190417103938.7762-23-jarkko.sakkinen@linux.intel.com>
 <20190625154341.GA7046@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551B873@ORSMSX116.amr.corp.intel.com>
 <20190711155428.GC15067@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <8bb023a5-d5d9-96c2-2596-2628206d5bd7@intel.com>
Date:   Thu, 11 Jul 2019 15:12:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190711155428.GC15067@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/11/2019 8:54 AM, Sean Christopherson wrote:
> On Thu, Jun 27, 2019 at 01:32:58PM -0700, Xing, Cedric wrote:
>> Just a reminder that #DB/#BP shall be treated differently because they are
>> used by debuggers. So instead of branching to the fixup address, the kernel
>> shall just signal the process.
> 
> More importantly, doing fixup on #DB and #BP simply doesn't work.

What's really needed is a signal, as if the fixup entry didn't exist.

You don't have to care whether a debugger is attached or not.

> On Tue, Apr 23, 2019 at 11:59:37AM -0700, Sean Christopherson wrote:
>> On Mon, Apr 22, 2019 at 06:29:06PM -0700, Andy Lutomirski wrote:
>>> What's not tested here is running this code with EFLAGS.TF set and
>>> making sure that it unwinds correctly.  Also, Jarkko, unless I missed
>>> something, the vDSO extable code likely has a bug.  If you run the
>>> instruction right before ENCLU with EFLAGS.TF set, then do_debug()
>>> will eat the SIGTRAP and skip to the exception handler.  Similarly, if
>>> you put an instruction breakpoint on ENCLU, it'll get skipped.  Or is
>>> the code actually correct and am I just remembering wrong?
>>
>> The code is indeed broken, and I don't see a sane way to make it not
>> broken other than to never do vDSO fixup on #DB or #BP.  But that's
>> probably the right thing to do anyways since an attached debugger is
>> likely the intended recipient the 99.9999999% of the time.
>>
>> The crux of the matter is that it's impossible to identify whether or
>> not a #DB/#BP originated from within an enclave, e.g. an INT3 in an
>> enclave will look identical to an INT3 at the AEP.  Even if hardware
>> provided a magic flag, #DB still has scenarios where the intended
>> recipient is ambiguous, e.g. data breakpoint encountered in the enclave
>> but on an address outside of the enclave, breakpoint encountered in the
>> enclave and a code breakpoint on the AEP, etc...

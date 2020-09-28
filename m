Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D68C2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 15:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E292100A
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 15:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgI1PnU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 11:43:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:3957 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgI1PnU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 11:43:20 -0400
IronPort-SDR: QgoqUqm7a4vlffvJdPQYxhxyLAuYTb4F21O1K+cfCXuE3HbEmi4svbBV4iETGZ0Qad/WQ7rTpn
 yYAvBC8RbuCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="161244135"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="161244135"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 08:43:18 -0700
IronPort-SDR: 4HdcopWKm89RfPFXQj4TehgDuEsxlZkQ+ZATP7L5KKTi5Sg2Ksxwil8TJGKZJHzKZwd0a4H0Be
 bk4zMUOb0KUw==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="307377637"
Received: from yyu32-mobl1.amr.corp.intel.com (HELO [10.212.93.46]) ([10.212.93.46])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 08:43:17 -0700
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        "H.J. Lu" <hjl.tools@gmail.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
From:   "Yu, Yu-cheng" <yu-cheng.yu@intel.com>
Message-ID: <c1b0019d-d3cb-cc62-f47f-90c2550c22a4@intel.com>
Date:   Mon, 28 Sep 2020 08:43:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 9/25/2020 11:23 AM, Andrew Cooper wrote:
> On 15/09/2020 12:28, Jarkko Sakkinen wrote:
>> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
>> new file mode 100644
>> index 000000000000..adbd59d41517
>> --- /dev/null
>> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
>> @@ -0,0 +1,157 @@
>> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
>> <snip>
>> +.Lretpoline:
>> +	call	2f
>> +1:	pause
>> +	lfence
>> +	jmp	1b
>> +2:	mov	%rax, (%rsp)
>> +	ret
> 
> I hate to throw further spanners in the work, but this is not compatible
> with CET, and the user shadow stack work in progress.

Hi Jarkko,

These 1: and 2: targets are reached only from these few lines?  If they 
are direct call/jmp targets, I think it is OK in terms of CET.  If they 
are reached from an instruction like "jmp *%rax", then we need to put in 
an "endbr64".

Yu-cheng

> 
> Whichever of these two large series lands first is going to inflict
> fixing this problem on the other.
> 
> As the vdso text is global (to a first approximation), it must not be a
> retpoline if any other process is liable to want to use CET-SS.
> 
> If the retpoline really does need to stay, then the vdso probably needs
> to gain suitable __x86_indirect_thunk_%reg thunks which are patched at
> boot based on the system properties.
> 
> ~Andrew
> 


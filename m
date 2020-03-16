Return-Path: <SRS0=nADd=5B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 151E6C0044D
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 23:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCAB720663
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 23:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbgCPX4p (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 19:56:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:49033 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732977AbgCPX4p (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Mar 2020 19:56:45 -0400
IronPort-SDR: eKRMza+1TLqcIExZrXkqF3lTUnWDDGkoInq4knORL7F5DQlchGBGOmVOlopSK7sn04nrFR5Yyr
 5cA+h8I8AOyw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 16:56:45 -0700
IronPort-SDR: uECgVr6/klVPAgp+iMzMUAOBIA0UfpBRAfaKDaluds/TyUrFHHfnKiGX00ZNVE8vJ/fuqtmLhx
 B6/0vT6Qqkpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,562,1574150400"; 
   d="scan'208";a="244308878"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.135.8.145]) ([10.135.8.145])
  by orsmga003.jf.intel.com with ESMTP; 16 Mar 2020 16:56:42 -0700
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <20200315012523.GC208715@linux.intel.com>
 <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
 <7f9f2efe-e9af-44da-6719-040600f5b351@fortanix.com>
 <20200316225534.GK24267@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <7634c48d-a8e2-7366-6f04-06a27f8e5eaf@intel.com>
Date:   Mon, 16 Mar 2020 16:56:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200316225534.GK24267@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/16/2020 3:55 PM, Sean Christopherson wrote:
> On Mon, Mar 16, 2020 at 02:31:36PM +0100, Jethro Beekman wrote:
>> Can someone remind me why we're not passing TCS in RBX but on the stack?
> 
> I finally remembered why.  It's pulled off the stack and passed into the
> exit handler.  I'm pretty sure the vDSO could take it in %rbx and manually
> save it on the stack, but I'd rather keep the current behavior so that the
> vDSO is callable from C (assuming @leaf is changed to be passed via %rcx).
> 
The idea is that the caller of this vDSO API is C callable, hence it 
cannot receive TCS in %rbx anyway. Then it has to either MOV to %rbx or 
PUSH to stack. Either way the complexity is the same. The vDSO API 
however has to always save it on stack for exit handler. So receiving it 
via stack ends up in simplest code.

Return-Path: <SRS0=LTc5=DG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129ABC2D0A8
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 01:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEECF208FE
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 01:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgI2BSd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 21:18:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:35482 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgI2BSd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 21:18:33 -0400
IronPort-SDR: iFNby29po1uDWdFmL5AOwkFICJfoq/W/fdd2ALkX//pWWc3TW4pMCPq08/nnv/xy1lf3vo0yIH
 wxb2mq985A+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="141475111"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="141475111"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 15:07:49 -0700
IronPort-SDR: QlGRTqEN4d8qtBxrb2skgkdPLBIZM2kFqgtNC1yKwoS0Zp6q+/PfjONCBSwsAQL+HfayEcCDz5
 SNVLTsJ6l8EQ==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="488780374"
Received: from jlasecki-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.49.78])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 15:07:42 -0700
Date:   Tue, 29 Sep 2020 01:07:40 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200928220740.GG2705@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
 <20200928005842.GC6704@linux.intel.com>
 <85bc15d5-93cd-e332-ae9a-1e1e66e1181d@citrix.com>
 <CAMe9rOpzXW0cSD=9E7drGEHH=pcm_NqvPiaR0pBJzYLeAt0_3g@mail.gmail.com>
 <CALCETrU4Rhc0fwzzKLSUgan2YmSovxVFYOZEmFnBHC4DbZ5RfQ@mail.gmail.com>
 <0edfbf96-32db-3565-0d07-7d4a4118dbe6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0edfbf96-32db-3565-0d07-7d4a4118dbe6@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 11:17:42AM -0700, Dave Hansen wrote:
> On 9/28/20 11:12 AM, Andy Lutomirski wrote:
> >> endbr64
> >> /* Check if shadow stack is in use.  NB: R11 is the only usable
> >>    scratch register for function calls.  */
> >> xorl %r11d, %r11d
> >> rdsspq %r11
> >> testq %r11, %r11
> >> jnz 3f
> >> call 2f
> >> 1:
> >> pause
> >> lfence
> >> jmp 1b
> >> 2:
> >> mov %rax, (%rsp)
> >> ret
> >> 3:
> >> /* Shadow stack is in use.  Make the indirect call.  */
> >> call *%rax
> >> ret
> > What do we expect user programs to do on CET systems?  It would be
> > nice if we could instead ALTERNATIVE this out if X86_FEATURE_SHSTK.
> 
> Shouldn't we just be able to use X86_FEATURE_RETPOLINE?
> 
> We probably need a mechanism to force X86_FEATURE_SHSTK and
> X86_FEATURE_RETPOLINE to be mutually exclusive if we don't have one already.

First of all: lets go with boot time patching instead of dynamic
detection. It's both easier to implement and by all other merits makes a
lot more sense. It was just a thing that I've not used before.

That sorted out, does it matter which direction I look it at? I could
use either feature flag as basis (and I do not have a personal
preference here).

/Jarkko

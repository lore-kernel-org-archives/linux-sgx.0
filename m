Return-Path: <SRS0=i6Eh=SA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A85C43381
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Mar 2019 09:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0553206B7
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Mar 2019 09:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfC2JsX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Mar 2019 05:48:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:24061 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbfC2JsX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 29 Mar 2019 05:48:23 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Mar 2019 02:48:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,284,1549958400"; 
   d="scan'208";a="218707977"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.156])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2019 02:48:14 -0700
Date:   Fri, 29 Mar 2019 11:48:14 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Message-ID: <20190329094814.GE21379@linux.intel.com>
References: <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
 <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com>
 <20190325180349.GF31069@linux.intel.com>
 <CALCETrXqb3CHefN-RLudC61jwdbLFS8cXuS4V5OJ6HTuf_arYw@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85FABF@ORSMSX116.amr.corp.intel.com>
 <CALCETrVcR_etAHSVZxvCz7CcPnF4ajpcWiRCtFrOckVWVJByHA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E860C69@ORSMSX116.amr.corp.intel.com>
 <CALCETrUUv3WSX7uL22DnWg8FOJqVyB=tknxbGDWb9wpx7zY2CQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E8617BF@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E8617BF@ORSMSX116.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 28, 2019 at 11:19:25PM +0000, Xing, Cedric wrote:
> > It's certainly making progress.  I like the fact that the callback is
> > now unconditional (if non-NULL) rather than being used just in case of
> > certain exit types.  But, if we go down this route, let's name and
> > document it appropriately -- just call the function "callback" and
> > document it as a function that is called just before
> > __vdso_sgx_enter_enclave returns, to be used if support for legacy
> > enclaves that push data onto the untrusted stack is needed.  We should
> > further document that it's safe to longjmp out of it.
> > 
> > Also, the tests in tools/testing/selftests/x86/unwind_vdso.c should be
> > augmented to test this code.
> > 
> > Finally, why does the vDSO code bother checking whether the leaf is
> > valid?
> 
> I can document it. I'll look into unwind_vdso.c to see what kind of
> selftests will make sense here. And I'll send out a RFC patch with
> everything included. Or would you prefer to have my changes integrated
> into Jarkko's patch v20?
> 
> Different ENCLU leaf has different parameters. This vDSO API knows how
> to load up parameters only for EENTER and ERESUME so it errs on all
> other positive values. 0 and negative values are interpreted as return
> codes. 

Not gonna make it to v20. I'm aiming to send it early next week and have
already closed the content.

What this and also Sean's solution would need is the update to
Documentation/x86/sgx.rst explaining how it works in detail.

/Jarkko

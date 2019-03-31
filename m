Return-Path: <SRS0=UDp8=SC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDED4C43381
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Mar 2019 09:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C58282146F
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Mar 2019 09:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfCaJEC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 Mar 2019 05:04:02 -0400
Received: from wind.enjellic.com ([76.10.64.91]:56710 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbfCaJEC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 Mar 2019 05:04:02 -0400
X-Greylist: delayed 1215 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Mar 2019 05:04:02 EDT
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x2V8hBd4031679;
        Sun, 31 Mar 2019 03:43:11 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x2V8h9ki031678;
        Sun, 31 Mar 2019 03:43:09 -0500
Date:   Sun, 31 Mar 2019 03:43:09 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
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
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Message-ID: <20190331084309.GA31645@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com> <20190325180349.GF31069@linux.intel.com> <CALCETrXqb3CHefN-RLudC61jwdbLFS8cXuS4V5OJ6HTuf_arYw@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F4E85FABF@ORSMSX116.amr.corp.intel.com> <CALCETrVcR_etAHSVZxvCz7CcPnF4ajpcWiRCtFrOckVWVJByHA@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F4E860C69@ORSMSX116.amr.corp.intel.com> <CALCETrUUv3WSX7uL22DnWg8FOJqVyB=tknxbGDWb9wpx7zY2CQ@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F4E8617BF@ORSMSX116.amr.corp.intel.com> <20190329094814.GE21379@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329094814.GE21379@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sun, 31 Mar 2019 03:43:11 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 29, 2019 at 11:48:14AM +0200, Jarkko Sakkinen wrote:

Good morning to everyone, I hope the weekend is going well.

> Not gonna make it to v20. I'm aiming to send it early next week and have
> already closed the content.

What is the status of your jarkko-sgx/next and jarkko-sgx/master
branches with respect to all of this?

We have our SFLC patch series currently staged on top of
jarkko-sgx/next and we will re-stage them on top of whatever you are
pushing upstream from.

> /Jarkko

Have a good remainder of the weekend.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Can't they?

 A 64bit number incremented every millisecond can grow for half a
 billion years.  As far as I'm concerned, that is forever."
                                -- Neil Brown
                                   linux-raid

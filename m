Return-Path: <SRS0=8iz8=RZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D379C43381
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 21:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02A152190A
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 21:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfCVVUT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Mar 2019 17:20:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:34486 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727075AbfCVVUS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Mar 2019 17:20:18 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 14:20:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="144426581"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga002.jf.intel.com with ESMTP; 22 Mar 2019 14:20:15 -0700
Date:   Fri, 22 Mar 2019 14:20:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Message-ID: <20190322212011.GD12666@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <CALCETrVKAUK-jZ7Knp7RetTL055p3iK1D8Wyr6=hPq5HkePkFg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C53D@ORSMSX116.amr.corp.intel.com>
 <20190320210313.GJ30469@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C6B5@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E85C6B5@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 20, 2019 at 05:17:53PM -0700, Xing, Cedric wrote:
> > On Wed, Mar 20, 2019 at 12:57:52PM -0700, Xing, Cedric wrote:
> > > > Using the untrusted stack as a way to exchange data is very
> > > > convenient, but that doesn't mean it's a good idea.  Here are some
> > > > problems it
> > > > causes:
> > > >
> > > >  - It prevents using a normal function to wrap enclave entry (as
> > > > we're seeing with this patch set).
> > >
> > > It doesn't prevent.
> > 
> > Yes it does, keyword being "normal".  Though I guess we could do a bit
> > of bikeshedding on the definition of normal...
> 
> I don't understand what you mean by "normal".

My apologies, I missed the code snippet in your original code, I was
thinking of a previous idea involving a JMP %rbp.  Please ignore this
bit of discussion.

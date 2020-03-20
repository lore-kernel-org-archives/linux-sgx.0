Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15B0C4332B
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 23:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDBD62072D
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 23:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgCTX0u (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Mar 2020 19:26:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:45223 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCTX0u (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Mar 2020 19:26:50 -0400
IronPort-SDR: qc1opcme9qmA5lMT2p7S6PxCbVlPo3V+v7btBYOBTBtIh74pYARKFc9nfHkKfAd5GDzXTBCZ8A
 FqZ5u7tZlQ6Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 16:26:49 -0700
IronPort-SDR: feHdry90Xn9tKjMWBLJFc+vg2Dd16NClQlhspuTxBzHR8AE6Oc/1NAbgIMVZEeJz9nhqVGfYtv
 Ggj+yL1nFVKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="238893607"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 20 Mar 2020 16:26:49 -0700
Date:   Fri, 20 Mar 2020 16:26:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 3/8] x86/sgx: vdso: Make
 __vdso_sgx_enter_enclave() callable from C code
Message-ID: <20200320232649.GG3866@linux.intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
 <20200319011130.8556-4-sean.j.christopherson@intel.com>
 <9a4878b9-bcad-b279-acd5-2eef03b13af8@intel.com>
 <20200319201144.GF11305@linux.intel.com>
 <20200320030700.GF183331@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320030700.GF183331@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 20, 2020 at 05:07:00AM +0200, Jarkko Sakkinen wrote:
> On Thu, Mar 19, 2020 at 01:11:45PM -0700, Sean Christopherson wrote:
> > On Thu, Mar 19, 2020 at 01:03:41PM -0700, Xing, Cedric wrote:
> > > On 3/18/2020 6:11 PM, Sean Christopherson wrote:
> > > >  #endif
> > > >  SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > > >  	/* Prolog */
> > > >@@ -82,7 +84,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > > >  	.cfi_rel_offset		%rbp, 0
> > > >  	mov	%rsp, %rbp
> > > >  	.cfi_def_cfa_register	%rbp
> > > >+	push	%rbx
> > > A CFI directive is needed here:
> > > 
> > > 	.cfi_rel_offset 	%rbx, -8
> > 
> > Darn, I suspected as much, but wasn't 100% positive.  Shouldn't have
> > hedged.  :-)
> > 
> > Is the rule of thumb for adding directives that one is needed any time
> > there is a new saved value of a register, or if the relative address of
> > the last saved value changes?  Are CFI directives only used for
> > non-volatile registers?
> 
> AFAIK the convention is just that if you push a register you need to
> offset it so that the FDE that is put into .eh_frame by GCC has the
> information from which locations of the stack the register values are
> copied.
> 
> BTW, why use GCC-style ".L-mangled" label names instead of having more
> readable ones?

Readable as in dropping the .L part?  E.g.

  enclu_eenter_eresume:

I assumed we'd want to keep the local labels out of the symbols file, but
maybe getting them in there would be a good thing?

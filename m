Return-Path: <SRS0=F+z5=DI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66B8C4727F
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 22:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62AD620739
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 22:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbgJAWud (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Oct 2020 18:50:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:55203 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgJAWud (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Oct 2020 18:50:33 -0400
IronPort-SDR: 3rArHu+eW3Ec2maoR2xzEX/BXbMQUKLEU/4knB/txA4tIy9igdk4QOt1lJ/6TpLOHDHQf2Jj4L
 IQFzzdIF7e2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="142258607"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="142258607"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 15:50:31 -0700
IronPort-SDR: Azt+OOpo6r+C/Tsp0fIscGXz4NBNLFy5wpTNgCQKl0yKCcM/jAdgEeeEExSUA+/x07vmIc/Kmn
 CG1DrMS0UgOA==
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="505981524"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 15:50:30 -0700
Date:   Thu, 1 Oct 2020 15:50:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
Subject: Re: [PATCH] x86/vdso: Flatten and clean up struct sgx_enclave_run
Message-ID: <20201001225029.GJ7474@linux.intel.com>
References: <20201001161642.10500-1-jarkko.sakkinen@linux.intel.com>
 <20201001165151.GE7474@linux.intel.com>
 <20201001204027.GA18610@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001204027.GA18610@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 02, 2020 at 12:46:11AM +0300, Jarkko Sakkinen wrote:
> On Thu, Oct 01, 2020 at 09:51:51AM -0700, Sean Christopherson wrote:
> > > Remove 'exit_reason' as it is really a redundant field to save some space.
> > > Instead, have just a field called 'leaf' that tells the last seen ENCLU.
> > 
> > This justification contradicts the removal of flags.  If you want to shave
> > bytes, keep flags and enforce that flags is zero so that you don't need to
> > have reserved bytes at the end of the struct.
> > 
> > IMO, having a separate exit reason provides saner code for userspace, e.g. 
> > 
> >   if (run->exit_reason == SGX_EXCEPTION_EXIT)
> > 	<do exception stuff>
> > 
> > versus
> > 
> >   if (run->leaf == EENTER || run->leaf == ERESUME)
> >         <do exception stuff>
> > 
> > I would prefer to be explicit about why the vDSO is transferring control to
> > the caller or its handler.  It also gives us line of sight to supporting
> > exit types other than EEXIT and exceptions.  Maybe we never end up with
> > another type, but IMO shaving 4 bytes and a MOV isn't worth the risk of
> > ending up with a mess of an API if another exit reason comes along.
> 
> 'exit_reason' is just waste of expensive memory space that we have
> limited fixed amount of.

Huh?  4 bytes on the user stack can't possibly be a real concern, the default
stack size on x86-64 is 8MB.  Golang shaves that down to 2kb but dynamically
adjusts the stack as needed.  The "allocation" is completely free, the caller
will already be adjusting RSP to create space for the struct, and it doesn't
need to be initialized.

> Using the same field in a *guaranteed*
> non-conflicting manner saves space. There is absolutely no question
> that what I did should not be done.

But you can't guarantee that it doesn't conflict with future changes to the
SGX architecture.  Hell, you can't even guarantee that it doesn't conflict
with the current SGX architecture, e.g. see Jethro's request to invoke the
handler on AEX's due to interrupts.

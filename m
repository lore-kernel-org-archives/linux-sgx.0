Return-Path: <SRS0=Uuw6=4I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534EEC11D19
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 19:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32FAD222C4
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 19:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgBTTPM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Feb 2020 14:15:12 -0500
Received: from mga05.intel.com ([192.55.52.43]:49172 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728111AbgBTTPM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Feb 2020 14:15:12 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 11:15:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="434935036"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 20 Feb 2020 11:15:10 -0800
Date:   Thu, 20 Feb 2020 11:15:10 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jordan Hand <jorhand@linux.microsoft.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Neil Horman <nhorman@redhat.com>, npmccallum@redhat.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>, puiterwijk@redhat.com,
        LSM List <linux-security-module@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
Message-ID: <20200220191510.GF3972@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
 <15074c16-4832-456d-dd12-af8548e46d6d@linux.microsoft.com>
 <20200220181345.GD3972@linux.intel.com>
 <CALCETrVXnSR8fBQtqv=3zFxJCFhcHE-6XNAy3suPW+uPgFvfvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVXnSR8fBQtqv=3zFxJCFhcHE-6XNAy3suPW+uPgFvfvg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 20, 2020 at 10:51:37AM -0800, Andy Lutomirski wrote:
> On Thu, Feb 20, 2020 at 10:13 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > More than likely, the READ_IMPLIES_EXECUTE (RIE) crud rears its head
> > because part of the enclave loader is written in assembly.  Unless
> > explicitly told otherwise, the linker assumes that any program with
> > assembly code may need an executable stack, which leads to the RIE
> > personality being set for the process.  Here's a fantastic write up for
> > more details: https://www.airs.com/blog/archives/518
> >
> > There are essentially two paths we can take:
> >
> >  1) Exempt EPC pages from RIE during mmap()/mprotect(), i.e. don't add
> >     PROT_EXEC for enclaves.
> 
> Seems reasonable.
> 
> Honestly, it probably makes sense to try to exempt almost everything
> from RIE.  I'd be a bit surprised if RIE is actually useful for
> anything other than plain anonymous pages and private file mappings.

Hmm, last I looked at this I was focused on adding a generic protections
manipulator, e.g. vm_ops->mprotect_adjust() and f_op->???, and I thought
those options were too ugly to pursue.

But if we want to start killing RIE specifically, adding a boolean flag
to and f_op wouldn't be _that_ heinous, e.g.

static int do_mprotect_pkey(...)
{
	...

		/* Does the application expect PROT_READ to imply PROT_EXEC */
		if (rier && (vma->vm_flags & VM_MAYEXEC) &&
		    (!vma->vm_file || !vma->vm_file->f_op->no_read_implies_exec))
			prot |= PROT_EXEC;
}

unsigned long do_mmap(...)
{
	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
		if (!file || (!path_noexec(&file->f_path) &&
			      !file->f_op->no_read_implies_exec))
			prot |= PROT_EXEC;
}

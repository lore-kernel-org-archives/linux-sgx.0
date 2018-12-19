Return-Path: <SRS0=HOZE=O4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BF8C43387
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 10:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA29721871
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 10:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbeLSKoH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Dec 2018 05:44:07 -0500
Received: from mga17.intel.com ([192.55.52.151]:17015 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbeLSKoH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Dec 2018 05:44:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2018 02:44:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,372,1539673200"; 
   d="scan'208";a="284967997"
Received: from unknown (HELO localhost) ([10.249.254.232])
  by orsmga005.jf.intel.com with ESMTP; 19 Dec 2018 02:44:00 -0800
Date:   Wed, 19 Dec 2018 12:43:59 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20181219104015.GA4863@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 19, 2018 at 09:36:16AM +0000, Jethro Beekman wrote:
> On 2018-12-19 14:41, Jarkko Sakkinen wrote:
> > On Wed, Dec 19, 2018 at 08:41:12AM +0000, Jethro Beekman wrote:
> > > One weird thing is the departure from the normal mmap behavior that the
> > > memory mapping persists even if the original fd is closed. (See man mmap:
> > > "closing the file descriptor does not unmap the region.")
> > 
> > The mmapped region and enclave would be completely disjoint to start
> > with. The enclave driver code would assume that an enclave VMA exists
> > when it maps enclave address space to a process.
> > 
> > I.e. VMA would no longer reference to the enclave or vice versa but
> > you would still create an enclave VMA with mmap().
> > 
> > This is IMHO very clear and well-defined semantics.
> > 
> > > > struct sgx_enclave_add_page {
> > > > 	__u64	enclave_fd;
> > > > 	__u64	src;
> > > > 	__u64	secinfo;
> > > > 	__u16	mrmask;
> > > > } __attribute__((__packed__));
> > > 
> > > Wouldn't you just pass enclave_fd as the ioctl fd parameter?
> > 
> > I'm still planning to keep the API in the device fd and use enclave_fd
> > as handle to the enclave address space. I don't see any obvious reason
> > to change that behavior.
> > 
> > And if we ever add any "global" ioctls, then we would have to define
> > APIs to both fd's, which would become a mess.
> > 
> > > How to specify the address of the page that is being added?
> > 
> > Yes, that is correct and my bad to remove it (just quickly drafted what
> > I had in mind).
> 
> So your plan is that to call EADD, userspace has to pass the device fd AND
> the enclave fd AND the enclave address? That seems a little superfluous.

If the enclave fd would have ioctls to add pages etc., two ioctls APIs
would be already needed now (create for device fd and rest to the
enclave fd). Which one would be more superfluous?

/Jarkko

Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF3DC2D0E4
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Nov 2020 19:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF80A2225B
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Nov 2020 19:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgKOTAi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:00:38 -0500
Received: from wind.enjellic.com ([76.10.64.91]:60690 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbgKOTAi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 15 Nov 2020 14:00:38 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0AFIxqvw026709;
        Sun, 15 Nov 2020 12:59:52 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0AFIxoc0026708;
        Sun, 15 Nov 2020 12:59:50 -0600
Date:   Sun, 15 Nov 2020 12:59:50 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v40 10/24] mm: Add 'mprotect' hook to struct vm_operations_struct
Message-ID: <20201115185950.GA26542@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com> <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com> <20201106174359.GA24109@wind.enjellic.com> <e70c9e92-0bd4-59a4-21b1-bccf8621c6bb@intel.com> <20201107150930.GA29530@wind.enjellic.com> <c7157bc6-8a65-11f4-e961-17163730df5d@intel.com> <20201112205819.GA9172@wind.enjellic.com> <5c22300c-0956-48ed-578d-00cf62cb5c09@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c22300c-0956-48ed-578d-00cf62cb5c09@intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sun, 15 Nov 2020 12:59:53 -0600 (CST)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 12, 2020 at 01:31:19PM -0800, Dave Hansen wrote:

Good afternoon to everyone.

> On 11/12/20 12:58 PM, Dr. Greg wrote:
> > @@ -270,11 +270,10 @@ static int sgx_vma_mprotect(struct vm_area_struct *vma,
> >  			    struct vm_area_struct **pprev, unsigned long start,
> >  			    unsigned long end, unsigned long newflags)
> >  {
> > -	int ret;
> > +	struct sgx_encl *encl = vma->vm_private_data;
> >  
> > -	ret = sgx_encl_may_map(vma->vm_private_data, start, end, newflags);
> > -	if (ret)
> > -		return ret;
> > +	if ( test_bit(SGX_ENCL_INITIALIZED, &encl->flags) )
> > +		return -EACCES;
> >  
> >  	return mprotect_fixup(vma, pprev, start, end, newflags);
> >  }

> This rules out mprotect() on running enclaves.  Does that break any
> expectations from enclave authors, or take away capabilities that
> folks need?

As I mentioned an hour or so ago when I posted our updated patch, Sean
and Jarkko have specifically indicated that there is no intention to
support Enclave Dynamic Memory Management (EDMM) at this stage of the
driver.  I believe the intent is to open that can of worms after the
driver is mainlined.

Since the stated intent of the driver is to only implement SGX1
semantics there is no need to allow page permission changes of any
type after the enclave is initialized.  If mmap/mprotect are taken off
the table for an initialized enclave, there is no need to walk the
enclave page permissions since the hardware itself will enforce those
intents.

Runtime support is critical to implementing EDMM.  It seems premature
to place code into the kernel until there is agreement from the
runtime developers as to how page permission intent should be
communicated into the kernel.  Current EDMM implementations simply
allocate a sparse aperture which can be further extended, for example,
to increase heap space or the number of Task Control Structures.

As I've stated previously, there is an open question at this point as
to how useful a mainline driver will be without EDMM support, unless
the distributions or cloud providers are going to patch it in on top
of the mainline driver.  Those players have been copied on all of
these e-mails so I would assume they could/would pipe up with comments
on what type of security architecture should be implemented.

As I've stated before, I believe in the final analysis that the only
relevant question is yes or no with respect to dynamic enclaves.

Have a good remainder of the weekend.

Dr. Greg

As always,
Greg Wettstein, Ph.D, Worker          Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If you think nobody cares if you're alive, try missing a couple of car
 payments."
                                -- Earl Wilson

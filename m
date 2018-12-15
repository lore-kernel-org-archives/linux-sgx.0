Return-Path: <SRS0=cH1o=OY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D98C43387
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Dec 2018 23:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF3EC206C2
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Dec 2018 23:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbeLOXZ3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 15 Dec 2018 18:25:29 -0500
Received: from wind.enjellic.com ([76.10.64.91]:57290 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbeLOXZ3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 15 Dec 2018 18:25:29 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wBFNMWWb023336;
        Sat, 15 Dec 2018 17:22:32 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wBFNMVui023334;
        Sat, 15 Dec 2018 17:22:31 -0600
Date:   Sat, 15 Dec 2018 17:22:31 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, jethro@fortanix.com
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181215232231.GA22773@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181126230436.GA6737@linux.intel.com> <20181127085533.GA12247@wind.enjellic.com> <20181127164129.GB4170@linux.intel.com> <C11C9312-65BC-460A-8F9F-608E101AE5C1@amacapital.net> <20181128104941.GA23077@wind.enjellic.com> <20181128192228.GC9023@linux.intel.com> <20181210104908.GA23132@wind.enjellic.com> <20181212180036.GC6333@linux.intel.com> <20181214235917.GA14049@wind.enjellic.com> <20181215000627.GA5799@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181215000627.GA5799@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 15 Dec 2018 17:22:33 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 14, 2018 at 04:06:27PM -0800, Sean Christopherson wrote:

Good afternoon, I hope the weekend is going well for everyone.

> On Fri, Dec 14, 2018 at 05:59:17PM -0600, Dr. Greg wrote:
> > On Wed, Dec 12, 2018 at 08:00:36PM +0200, Jarkko Sakkinen wrote:
> > 
> > Good evening, I hope the week has gone well for everyone.
> > 
> > > On Mon, Dec 10, 2018 at 04:49:08AM -0600, Dr. Greg wrote:
> > > > In the meantime, I wanted to confirm that your jarkko-sgx/master
> > > > branch contains the proposed driver that is headed upstream.
> > > > Before adding the SFLC patches we thought it best to run the
> > > > driver through some testing in order to verify that any problems
> > > > we generated where attributable to our work and not the base
> > > > driver.
> > >
> > > The master branch is by definition unstable at the moment i.e. it
> > > can sometimes (not often) contain unfinished changes. Use next for
> > > testing.  I update next when I consider the master contents "stable
> > > enough".
> > 
> > I noticed in the last day or so that you appeared to sync
> > jarkko-sgx/master with jarkko-sgx/next, so I checked out a local
> > branch against jarkko-sgx/next and ran it against our unit tests.
> > Based on what we are seeing the driver is still experiencing issues
> > with initialization of a non-trivial enclave.

> master branch is broken, looks like the VMA code Jarkko is reworking is
> buggy.  I should be able to help debug this next week.
> 
> [  504.149548] ------------[ cut here ]------------
> [  504.149550] kernel BUG at /home/sean/go/src/kernel.org/linux/mm/mmap.c:669!

Rodger, dodger.

Let us know when you think you have something working pushed up into
one of the branches and we will put it on the bench here in the lab
and see what our runtime is able to do with it.

BTW, your new vDSO work appears to be shaping up well.  Just out of
curiosity though, how are you testing and validating the new vDSO
based exception handler if it isn't possible to initialize and run an
enclave with the new driver?

We will look forward to hearing from you.

Have a good remainder of the weekend.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Don't worry about people stealing your ideas.  If your ideas are any
 good, you'll have to ram them down people's throats."
                                -- Howard Aiken

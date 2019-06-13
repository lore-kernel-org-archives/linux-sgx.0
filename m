Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA86C31E4B
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20B9E2084D
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbfFMQyO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:54:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:44764 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbfFMQyN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 12:54:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 09:54:12 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jun 2019 09:54:12 -0700
Date:   Thu, 13 Jun 2019 09:54:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH 5/7] x86/sgx: Add flag to zero added region instead of
 copying from source
Message-ID: <20190613165412.GC5850@linux.intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-6-sean.j.christopherson@intel.com>
 <CALCETrXkWHOFUD0erQ+TZMY3VmGJz8=tk9rXOtdi8fP_GDEKCA@mail.gmail.com>
 <20190606173243.GE23169@linux.intel.com>
 <A948B013-BCA7-4C76-B816-CC27F38BF761@amacapital.net>
 <20190610185340.GJ15995@linux.intel.com>
 <35dd5d44-5ddf-09d3-e2d3-8570b2cdf6f5@fortanix.com>
 <20190613134603.GA5850@linux.intel.com>
 <CALCETrXmB=fFQSUdj0Zt8yRP7nbat=m3oyvhbDxQDCR52Gbw5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXmB=fFQSUdj0Zt8yRP7nbat=m3oyvhbDxQDCR52Gbw5A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 13, 2019 at 09:16:46AM -0700, Andy Lutomirski wrote:
> On Thu, Jun 13, 2019 at 6:46 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Thu, Jun 13, 2019 at 12:38:02AM +0000, Jethro Beekman wrote:
> > > On 2019-06-10 11:53, Sean Christopherson wrote:
> > > >On Fri, Jun 07, 2019 at 12:32:23PM -0700, Andy Lutomirski wrote:
> > > >>
> > > >>>On Jun 6, 2019, at 10:32 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > > >>>
> > > >>>>On Thu, Jun 06, 2019 at 10:20:38AM -0700, Andy Lutomirski wrote:
> > > >>>>On Wed, Jun 5, 2019 at 12:49 PM Sean Christopherson
> > > >>>><sean.j.christopherson@intel.com> wrote:
> > > >>>>>
> > > >>>>>For some enclaves, e.g. an enclave with a small code footprint and a
> > > >>>>>large working set, the vast majority of pages added to the enclave are
> > > >>>>>zero pages.  Introduce a flag to denote such zero pages.  The major
> > > >>>>>benefit of the flag will be realized in a future patch to use Linux's
> > > >>>>>actual zero page as the source, as opposed to explicitly zeroing the
> > > >>>>>enclave's backing memory.
> > > >>>>>
> > > >>>>
> > > >>>>I feel like I probably asked this at some point, but why is there a
> > > >>>>workqueue here at all?
> > > >>>
> > > >>>Performance.  A while back I wrote a patch set to remove the worker queue
> > > >>>and discovered that it tanks enclave build time when the enclave is being
> > > >>>hosted by a Golang application.  Here's a snippet from a mail discussing
> > > >>>the code.
> > > >>>
> > > >>>    The bad news is that I don't think we can remove the add page worker
> > > >>>    as applications with userspace schedulers, e.g. Go's M:N scheduler,
> > > >>>    can see a 10x or more throughput improvement when using the worker
> > > >>>    queue.  I did a bit of digging for the Golang case to make sure I
> > > >>>    wasn't doing something horribly stupid/naive and found that it's a
> > > >>>    generic issue in Golang with blocking (or just long-running) system
> > > >>>    calls.  Because Golang multiplexes Goroutines on top of OS threads,
> > > >>>    blocking syscalls introduce latency and context switching overhead,
> > > >>>    e.g. Go's scheduler will spin up a new OS thread to service other
> > > >>>    Goroutines after it realizes the syscall has blocked, and will later
> > > >>>    destroy one of the OS threads so that it doesn't build up too many
> > > >>>    unused.
> > > >>>
> > > >>>IIRC, the scenario is spinning up several goroutines, each building an
> > > >>>enclave.  I played around with adding a flag to do a synchronous EADD
> > > >>>but didn't see a meaningful change in performance for the simple case.
> > > >>>Supporting both the worker queue and direct paths was complex enough
> > > >>>that I decided it wasn't worth the trouble for initial upstreaming.
> > > >>
> > > >>Sigh.
> > > >>
> > > >>It seems silly to add a workaround for a language that has trouble calling
> > > >>somewhat-but-not-too-slow syscalls or ioctls.
> > > >>
> > > >>How about fixing this in Go directly?  Either convince the golang people to
> > > >>add a way to allocate a real thread for a particular region of code or have
> > > >>the Go SGX folks write a bit of C code to do  a whole bunch of ioctls and
> > > >>have Go call *that*.  Then the mess stays in Go where it belongs.
> > > >
> > > >Actually, I'm pretty sure changing the ioctl() from ADD_PAGE to ADD_REGION
> > > >would eliminate the worst of the golang slowdown without requiring
> > > >userspace to get super fancy.  I'm in favor of eliminating the work queue,
> > > >especially if the UAPI is changed to allow adding multiple pages in a
> > > >single syscall.
> > > >
> > >
> > > I don't know if this is going to matter a whole lot, but have you considered
> > > the performance impact of needing to the EPC paging while doing the EADD
> > > ioctl and how this interacts with having a workqueue?
> >
> > Yep, other than the goroutine case, eliminating the workqueue doesn't
> > substantially affect performance in either direction, regardless of the
> > pressure on the EPC.
> 
> It should get rid of some extra copies and allocations, no?

My experiments were fairly dumb, e.g. removed the workqueue without doing
extra enhancements like avoiding copy_from_user.  IIRC, the type of
allocation changed, but the number of copies/allocations stayed the same.

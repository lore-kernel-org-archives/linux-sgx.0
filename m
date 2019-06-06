Return-Path: <SRS0=qw+Y=UF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A909CC04AB5
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 17:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CA642083D
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 17:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfFFRco (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Jun 2019 13:32:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:8560 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbfFFRco (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 6 Jun 2019 13:32:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 10:32:43 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga007.jf.intel.com with ESMTP; 06 Jun 2019 10:32:43 -0700
Date:   Thu, 6 Jun 2019 10:32:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH 5/7] x86/sgx: Add flag to zero added region instead of
 copying from source
Message-ID: <20190606173243.GE23169@linux.intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-6-sean.j.christopherson@intel.com>
 <CALCETrXkWHOFUD0erQ+TZMY3VmGJz8=tk9rXOtdi8fP_GDEKCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXkWHOFUD0erQ+TZMY3VmGJz8=tk9rXOtdi8fP_GDEKCA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 06, 2019 at 10:20:38AM -0700, Andy Lutomirski wrote:
> On Wed, Jun 5, 2019 at 12:49 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > For some enclaves, e.g. an enclave with a small code footprint and a
> > large working set, the vast majority of pages added to the enclave are
> > zero pages.  Introduce a flag to denote such zero pages.  The major
> > benefit of the flag will be realized in a future patch to use Linux's
> > actual zero page as the source, as opposed to explicitly zeroing the
> > enclave's backing memory.
> >
> 
> I feel like I probably asked this at some point, but why is there a
> workqueue here at all?

Performance.  A while back I wrote a patch set to remove the worker queue
and discovered that it tanks enclave build time when the enclave is being
hosted by a Golang application.  Here's a snippet from a mail discussing
the code.

    The bad news is that I don't think we can remove the add page worker
    as applications with userspace schedulers, e.g. Go's M:N scheduler,
    can see a 10x or more throughput improvement when using the worker
    queue.  I did a bit of digging for the Golang case to make sure I
    wasn't doing something horribly stupid/naive and found that it's a
    generic issue in Golang with blocking (or just long-running) system
    calls.  Because Golang multiplexes Goroutines on top of OS threads,
    blocking syscalls introduce latency and context switching overhead,
    e.g. Go's scheduler will spin up a new OS thread to service other
    Goroutines after it realizes the syscall has blocked, and will later
    destroy one of the OS threads so that it doesn't build up too many
    unused.

IIRC, the scenario is spinning up several goroutines, each building an
enclave.  I played around with adding a flag to do a synchronous EADD
but didn't see a meaningful change in performance for the simple case.
Supporting both the worker queue and direct paths was complex enough
that I decided it wasn't worth the trouble for initial upstreaming.

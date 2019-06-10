Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B82C4321A
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 18:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5FE8207E0
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 18:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388381AbfFJSJw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 14:09:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:14613 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388052AbfFJSJw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 14:09:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 11:09:51 -0700
X-ExtLoop1: 1
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga006.jf.intel.com with ESMTP; 10 Jun 2019 11:09:50 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 10 Jun 2019 11:09:51 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.7]) with mapi id 14.03.0415.000;
 Mon, 10 Jun 2019 11:09:50 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Jethro Beekman" <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [PATCH 5/7] x86/sgx: Add flag to zero added region instead of
 copying from source
Thread-Topic: [PATCH 5/7] x86/sgx: Add flag to zero added region instead of
 copying from source
Thread-Index: AQHVG9fL6//sLB6t1UekNcOi7B7YnKaPVfoAgAADYICAAbPEgIAEKPiw
Date:   Mon, 10 Jun 2019 18:09:50 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654FFDD3@ORSMSX116.amr.corp.intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-6-sean.j.christopherson@intel.com>
 <CALCETrXkWHOFUD0erQ+TZMY3VmGJz8=tk9rXOtdi8fP_GDEKCA@mail.gmail.com>
 <20190606173243.GE23169@linux.intel.com>
 <A948B013-BCA7-4C76-B816-CC27F38BF761@amacapital.net>
In-Reply-To: <A948B013-BCA7-4C76-B816-CC27F38BF761@amacapital.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTBjODRkZmMtMjBjMy00YTg2LWI2ZDctNjYxNTE5YjgwZDJjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibUlLVkZMdWFQakkwa0w5VksxOTlXSVR4ajZjdHlEYUFEUjViYjNqc0ppbU0wbjE3U3hFZzVWMDg1UzFlWjlMTiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Friday, June 07, 2019 12:32 PM
> 
> > On Jun 6, 2019, at 10:32 AM, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> >> On Thu, Jun 06, 2019 at 10:20:38AM -0700, Andy Lutomirski wrote:
> >> On Wed, Jun 5, 2019 at 12:49 PM Sean Christopherson
> >> <sean.j.christopherson@intel.com> wrote:
> >>>
> >>> For some enclaves, e.g. an enclave with a small code footprint and a
> >>> large working set, the vast majority of pages added to the enclave
> >>> are zero pages.  Introduce a flag to denote such zero pages.  The
> >>> major benefit of the flag will be realized in a future patch to use
> >>> Linux's actual zero page as the source, as opposed to explicitly
> >>> zeroing the enclave's backing memory.
> >>>
> >>
> >> I feel like I probably asked this at some point, but why is there a
> >> workqueue here at all?
> >
> > Performance.  A while back I wrote a patch set to remove the worker
> > queue and discovered that it tanks enclave build time when the enclave
> > is being hosted by a Golang application.  Here's a snippet from a mail
> > discussing the code.
> >
> >    The bad news is that I don't think we can remove the add page
> worker
> >    as applications with userspace schedulers, e.g. Go's M:N scheduler,
> >    can see a 10x or more throughput improvement when using the worker
> >    queue.  I did a bit of digging for the Golang case to make sure I
> >    wasn't doing something horribly stupid/naive and found that it's a
> >    generic issue in Golang with blocking (or just long-running) system
> >    calls.  Because Golang multiplexes Goroutines on top of OS threads,
> >    blocking syscalls introduce latency and context switching overhead,
> >    e.g. Go's scheduler will spin up a new OS thread to service other
> >    Goroutines after it realizes the syscall has blocked, and will
> later
> >    destroy one of the OS threads so that it doesn't build up too many
> >    unused.
> >
> > IIRC, the scenario is spinning up several goroutines, each building an
> > enclave.  I played around with adding a flag to do a synchronous EADD
> > but didn't see a meaningful change in performance for the simple case.
> > Supporting both the worker queue and direct paths was complex enough
> > that I decided it wasn't worth the trouble for initial upstreaming.
> 
> Sigh.
> 
> It seems silly to add a workaround for a language that has trouble
> calling somewhat-but-not-too-slow syscalls or ioctls.
> 
> How about fixing this in Go directly?  Either convince the golang people
> to add a way to allocate a real thread for a particular region of code
> or have the Go SGX folks write a bit of C code to do  a whole bunch of
> ioctls and have Go call *that*.  Then the mess stays in Go where it
> belongs.

The add page worker is less about performance but more about concurrency restrictions in SGX ISA. EADD/EEXTEND are slow instructions and both take lock on the SECS. So if there's another EADD/EEXTEND in progress then it will #GP.

In practice, no sane applications will EADD in multiple threads because that would make MRENCLAVE unpredictable. But adversary may use that just to trigger #GP in kernel. Therefore, the SGX module would have to lock around EADD/EEXTEND anyway. And then we figured it would be better to have the add page worker so that no lock would be necessary, plus (small) improvement in performance. 

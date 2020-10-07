Return-Path: <SRS0=a0UF=DO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D16C41604
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 17:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FFFF2173E
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 17:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgJGRVF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Oct 2020 13:21:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:3040 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbgJGRVF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Oct 2020 13:21:05 -0400
IronPort-SDR: CC0gP24WxnrXGc/qOcbPyueGY08EuhLU82CZ7VxsLxe2VNON+kFcuNWfbjCL/gWUhDFvatqpbj
 qd7lusSqDgJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="229185307"
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="229185307"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:21:04 -0700
IronPort-SDR: bTozWrYkpt4AV1/0taoHgTUfaztcrylrOwTCsichN2yDZuDn6gzyTZ9iV85EivgDAkDRCgGFJA
 jh8PKWGx9K7A==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="528062272"
Received: from dumser-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.51.100])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:21:02 -0700
Date:   Wed, 7 Oct 2020 20:20:58 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: Unable to load large enclave
Message-ID: <20201007172058.GD3885@linux.intel.com>
References: <9393934c-e390-a7df-2e74-08f16d4f48d4@fortanix.com>
 <20200930011650.GA808399@linux.intel.com>
 <81e38a1b-c9a7-209e-76f5-e2c91f49c1e3@fortanix.com>
 <20200930114554.GA7612@linux.intel.com>
 <20201005225652.GD15803@linux.intel.com>
 <20201006151328.GA109815@linux.intel.com>
 <20201007154938.GA19072@linux.intel.com>
 <f362318e-2d14-c82d-82a8-35c35842f84c@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f362318e-2d14-c82d-82a8-35c35842f84c@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 07, 2020 at 06:13:49PM +0200, Jethro Beekman wrote:
> On 2020-10-07 17:49, Jarkko Sakkinen wrote:
> > On Tue, Oct 06, 2020 at 06:13:28PM +0300, Jarkko Sakkinen wrote:
> >> On Mon, Oct 05, 2020 at 03:56:52PM -0700, Sean Christopherson wrote:
> >>> On Wed, Sep 30, 2020 at 02:45:54PM +0300, Jarkko Sakkinen wrote:
> >>>> On Wed, Sep 30, 2020 at 09:12:06AM +0200, Jethro Beekman wrote:
> >>>>> On 2020-09-30 03:16, Jarkko Sakkinen wrote:
> >>>>>> On Tue, Sep 29, 2020 at 05:52:48PM +0200, Jethro Beekman wrote:
> >>>>>>> Since the latest API changes, I'm unable to load a large enclave. The
> >>>>>>> test program at
> >>>>>>> https://github.com/fortanix/rust-sgx/blob/sgx-load-large-enclave-test/src/main.rs
> >>>>>>> always fails with ENOMEM after loading 0xffd6 pages.
> >>>>>>>
> >>>>>>> I've tested this with v36, if there's reason to believe it has been
> >>>>>>> fixed I'd be happy to try it out on a newer patch set.
> >>>>>>
> >>>>>> I recommend using v39-rc1 tag that I created for testing because API is
> >>>>>> reverted back to be compatible with v36.
> >>>>>
> >>>>> Not sure what you're saying. I tested with v36. You're saying v39-rc1
> >>>>> will be the same? Or did you fix the issue since v36?
> >>>>
> >>>> v37 and v38 has an API change that is reverted in v39:
> >>>>
> >>>> https://lore.kernel.org/linux-sgx/20200921195822.GA58176@linux.intel.com/
> >>>>
> >>>> I'm not sure of the root cause yet but you asked to try to out a newer
> >>>> patch set and v39-rc1 is the best option.
> >>>>
> >>>> There was off-by-one error in enclave maximum size calculation fixed in
> >>>> v37 (it was actually a bug in SDM inherited to the code) but that should
> >>>> not result the situation you just described.
> >>>
> >>> My money is on the XArray changes, that's the most notable change in v36 and
> >>> IIRC the only thing that touched EPC/memory management.
> >>
> >> Yeah, that's what we've been speculating for some days now. That's
> >> somewhat deprecated email. It all started to enroll when I asked
> >> Haitao to turn CONFIG_PROVE_LOCKING on, and we got the information
> >> required to root cause the bug.
> > 
> > I run the failing test and filtered SGX mmap's and ioctl's with this
> > eBPF script:
> > 
> > kretprobe:sgx_ioctl /retval != 0/
> > {
> >         printf("sgx_ioctl: %d\n", retval)
> > }
> > 
> > kretprobe:sgx_mmap /retval != 0/
> > {
> >         printf("sgx_mmap: %d\n", retval)
> > }
> > 
> > This results zero positives, i.e. empty output, when run with bpftrace.
> > 
> > I'd go instead after RLIMIT_AS [*].
> > 
> > With these conclusions, I'm done with this bug.
> > 
> 
> How can it be RLIMIT_AS? With the current flow, you mmap the whole range before mmaping the individual pages over it?
> 
> Also, I can easily load a 1GB enclave with the old driver.
> 
> Also:
> 
> $ ulimit -v
> unlimited

➜  ~ (master) ✔ sudo bpftrace sgx_ret.bt
Attaching 3 probes...
ksys_mmap_pgoff: -12
^C

~ (master) ✔ cat sgx_ret.bt
kretprobe:sgx_ioctl /retval != 0/
{
        printf("sgx_ioctl: %d\n", retval)
}

kretprobe:sgx_mmap /retval != 0/
{
        printf("sgx_mmap: %d\n", retval)
}

kretprobe:ksys_mmap_pgoff /retval == (uint64)-12/
{
        printf("ksys_mmap_pgoff: %d\n", retval)
}

This shows that it fails before reaching sgx_mmap().

/Jarkko

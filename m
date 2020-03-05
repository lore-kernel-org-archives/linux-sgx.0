Return-Path: <SRS0=iPl9=4W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AA3C3F2D1
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 21:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F5AE20801
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 21:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgCEVAd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 5 Mar 2020 16:00:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:1897 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgCEVAd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 5 Mar 2020 16:00:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 13:00:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,519,1574150400"; 
   d="scan'208";a="441685376"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 05 Mar 2020 13:00:31 -0800
Date:   Thu, 5 Mar 2020 13:00:31 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Dr. Greg" <greg@enjellic.com>, Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20200305210031.GR11500@linux.intel.com>
References: <ed49f988-e4e5-b2b9-0108-f489e9b5f449@fortanix.com>
 <20200217185512.GA7677@linux.intel.com>
 <20200218104243.GA13967@wind.enjellic.com>
 <20200218155247.GA18374@linux.intel.com>
 <20200219162640.GA29921@wind.enjellic.com>
 <20200220195537.GA23349@linux.intel.com>
 <20200221011913.GA15165@wind.enjellic.com>
 <20200221130009.GB3112@linux.intel.com>
 <20200305195157.GO11500@linux.intel.com>
 <1bd3295e-02b3-ac5c-8545-0bb8cbd4cf48@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bd3295e-02b3-ac5c-8545-0bb8cbd4cf48@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 05, 2020 at 09:34:01PM +0100, Jethro Beekman wrote:
> On 2020-03-05 20:51, Sean Christopherson wrote:
> > On Fri, Feb 21, 2020 at 03:00:31PM +0200, Jarkko Sakkinen wrote:
> >> On Thu, Feb 20, 2020 at 07:19:13PM -0600, Dr. Greg wrote:
> >>>>> This would seem to imply that the driver is rather firmly architected
> >>>>> on the notion of one open() per enclave, a concept that Jethro seems
> >>>>> to have issues with.
> >>>
> >>>> I don't understand what concept you are talking about.
> >>>
> >>> If memory serves me correctly, Jethro envisioned a model where a
> >>> single open of the SGX driver node would return a file descriptor that
> >>> could then be used to create/load/initialize multiple enclaves.  Your
> >>> clarifications indicate that a separate open will be needed for each
> >>> and every enclave instance that will be orchestrated.
> >>>
> >>> Jethro, if I'm mistating your position on this, please jump in and
> >>> clarify.
> >>
> >> Ah.
> >>
> >> You are speaking about having a factory to create enclaves and a
> >> management interface. I.e. you'd have ioctl to create enclave that gives
> >> you a file descriptor to access its management interface.
> >>
> >> Out of top of my head I cannot recall why this was not favored in the
> >> end but generally speaking added complexity should be justified by some
> >> considerably strong measures.
> > 
> > The primary issue is that having an ioctl() to create enclaves means the
> > enclave fd would be an anon inode.
> 
> Why would it have to be an anon inode? Can't it just be the same inode as the
> device file? As I mentioned it just needs to be a different struct file
> (since that's what actually owns the enclave). I'm envisioning you still need
> to open the device first (once).

Hmm, poking around, alloc_file_clone() looks like it would do the trick.
But we are waaaaay outside my area of expertise, I'll let Andy or someone
else weigh in on whether or not this is sane.

> Yes, a UDS with SCM_RIGHTS could work, this is similar from a capability
> model perspective. It does make things a lot more complicated if you want to
> employ userspace security techniques. For example, when using seccomp a
> common use is to avoid the creation of arbitrary fds. It's rather hard to
> write a good set of rules for recvmsg with SCM_RIGHTS since the fds are
> passed from outside. Whitelisting a single ioctl is much easier. Also, you'd
> need to create a whole separate process whose job it is to hand out these
> enclave fds. That process still needs to be privileged and would probably
> need its own set of seccomp rules.
> 
> -- Jethro Beekman | Fortanix
> 



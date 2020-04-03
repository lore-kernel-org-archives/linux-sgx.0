Return-Path: <SRS0=nYZY=5T=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1965EC43331
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 15:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBCFD20721
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 15:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404011AbgDCPat (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Apr 2020 11:30:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:63010 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbgDCPat (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 3 Apr 2020 11:30:49 -0400
IronPort-SDR: zy2uc2lwxCC7Kbx1P3lJ5oqcq5nVpSSxiJqBQDEAIeifqCB18etYMEDOVsa1YKvXkal4P6kUKO
 6BsAFJ+1zEMQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 08:30:46 -0700
IronPort-SDR: kE3O9vKAYuNHHs0LrnUFZnq6GjnjjuWgv9MjaDasBG7weLVFyRVhmktTxNKEObvcQTrhYpRzSZ
 huHj42ysXmpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,340,1580803200"; 
   d="scan'208";a="396768569"
Received: from kinyauho-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.60.59])
  by orsmga004.jf.intel.com with ESMTP; 03 Apr 2020 08:30:42 -0700
Date:   Fri, 3 Apr 2020 18:30:41 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200403153041.GA2787@linux.intel.com>
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
 <20200331114432.7593-3-jarkko.sakkinen@linux.intel.com>
 <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
 <20200401002443.GE4847@linux.intel.com>
 <CALCETrW8pLFRAnQdpxuBG-CDuUN5B8T-FqN5TvAVD--ZR=78-Q@mail.gmail.com>
 <20200403065621.GB25305@linux.intel.com>
 <f8698536-074e-6562-05df-26145a4c43b9@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8698536-074e-6562-05df-26145a4c43b9@schaufler-ca.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 03, 2020 at 07:35:16AM -0700, Casey Schaufler wrote:
> 
> On 4/2/2020 11:56 PM, Jarkko Sakkinen wrote:
> > On Thu, Apr 02, 2020 at 02:41:39PM -0700, Andy Lutomirski wrote:
> >> On Tue, Mar 31, 2020 at 5:24 PM Sean Christopherson
> >> <sean.j.christopherson@intel.com> wrote:
> >>> On Tue, Mar 31, 2020 at 10:39:38AM -0700, Andy Lutomirski wrote:
> >>>
> >>> If EXECMEM is a sticking point, one way to dodge it would be to add a
> >>> helper to allow SELinux to detect enclave files.  It'd be ugly, but simple.
> >>> That doesn't solve the generic labeling issue though.  It also begs the
> >>> question of why hacking SELinux but not do_mmap() would be acceptable.
> >>>
> >>> If you have any ideas for fixing the noexec issue without resorting to an
> >>> anon inode, we're all ears.
> >> Hmm.  Maybe teach udev to put /dev/sgx on a different fs and
> >> bind-mount it?  Or make /dev/sgx be an actual filesystem?  Or just
> >> mount /dev with exec enabled?
> > I'm not forseeing how the last option could work out as it is distro's
> > choice.
> >
> > Casey, do you think we could use securityfs for this or do you have some
> > other recommendation? I'm just asking you because you've used securityfs
> > a lot.
> 
> I don't know how well securityfs works when mounted in a container,
> but otherwise it would seem like a viable option. On the other hand,
> pseudo filesystems are pretty easy to write, so /sys/fs/sgxfs wouldn't
> be a bad choice, either.

Ugh, sorry, forgot for a while that smackfs is independent fs.

How does smackfs interact with namespaces?

/Jarkko

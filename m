Return-Path: <SRS0=nYZY=5T=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE489C43331
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 07:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C83420787
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 07:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgDCHAF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Apr 2020 03:00:05 -0400
Received: from mga06.intel.com ([134.134.136.31]:37258 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729423AbgDCHAF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 3 Apr 2020 03:00:05 -0400
IronPort-SDR: f8uFHTYmz4QAqEyk4Tg6V/srZPHskMeVPdzjPjUIOBM59AbzKXA2Ei9eJKgysVB1GWsDfPL14k
 TvGhs6Pk7VIw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 00:00:04 -0700
IronPort-SDR: wJwR1lMrG9O3i9nZ3jzwGafU0Ps5YQW8/EVr+hnSL/hQ++ruBya2FK7YSdyd1Rq0k/L4OCc5Pb
 JcxO9axqHI1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,338,1580803200"; 
   d="scan'208";a="285029618"
Received: from kboulton-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.35.93])
  by fmsmga002.fm.intel.com with ESMTP; 02 Apr 2020 23:59:59 -0700
Date:   Fri, 3 Apr 2020 09:59:49 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200403065937.GC25305@linux.intel.com>
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
 <20200331114432.7593-3-jarkko.sakkinen@linux.intel.com>
 <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
 <20200401002443.GE4847@linux.intel.com>
 <CALCETrW8pLFRAnQdpxuBG-CDuUN5B8T-FqN5TvAVD--ZR=78-Q@mail.gmail.com>
 <20200403065621.GB25305@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403065621.GB25305@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 03, 2020 at 09:56:32AM +0300, Jarkko Sakkinen wrote:
> On Thu, Apr 02, 2020 at 02:41:39PM -0700, Andy Lutomirski wrote:
> > On Tue, Mar 31, 2020 at 5:24 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Tue, Mar 31, 2020 at 10:39:38AM -0700, Andy Lutomirski wrote:
> > >
> > > If EXECMEM is a sticking point, one way to dodge it would be to add a
> > > helper to allow SELinux to detect enclave files.  It'd be ugly, but simple.
> > > That doesn't solve the generic labeling issue though.  It also begs the
> > > question of why hacking SELinux but not do_mmap() would be acceptable.
> > >
> > > If you have any ideas for fixing the noexec issue without resorting to an
> > > anon inode, we're all ears.
> > 
> > Hmm.  Maybe teach udev to put /dev/sgx on a different fs and
> > bind-mount it?  Or make /dev/sgx be an actual filesystem?  Or just
> > mount /dev with exec enabled?
> 
> I'm not forseeing how the last option could work out as it is distro's
> choice.
> 
> Casey, do you think we could use securityfs for this or do you have some
> other recommendation? I'm just asking you because you've used securityfs
> a lot.

I'll squash 1/4 from this patch set since it is purely a fix.

/Jarkko

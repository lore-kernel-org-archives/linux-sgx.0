Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFC2C2BA17
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 19:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69CDA206F5
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 19:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgDFTBJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 15:01:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:8178 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgDFTBJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 15:01:09 -0400
IronPort-SDR: D5VYX71LuOtIKojo1bJR1fYkmZY7iZotEK1umRxKd3tYdKXnK5mEMvM4Qr5P2QitjF1jZxk1Xr
 SdAtD5o7PtJg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 12:01:07 -0700
IronPort-SDR: PFjCUHj8Cnw6QbupBcXLcjXKeJ2gjpG7Zke9/9ZLdP0fHKiAR2x8o0HAnEErJX5tbYoF+5lnmO
 +7nuMCgmvuzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,352,1580803200"; 
   d="scan'208";a="269169637"
Received: from yweiss1-mobl.ger.corp.intel.com (HELO localhost) ([10.252.49.159])
  by orsmga002.jf.intel.com with ESMTP; 06 Apr 2020 12:01:04 -0700
Date:   Mon, 6 Apr 2020 22:01:03 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200406190103.GF20105@linux.intel.com>
References: <dd2529f7-6079-e1ef-130d-648cc6e0b9b6@gmail.com>
 <0F11A8CE-912C-4920-B281-F5AC8C0AFF36@amacapital.net>
 <20200406185530.GE20105@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200406185530.GE20105@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 06, 2020 at 09:55:34PM +0300, Jarkko Sakkinen wrote:
> On Mon, Apr 06, 2020 at 09:44:19AM -0700, Andy Lutomirski wrote:
> > 
> > > On Apr 6, 2020, at 4:01 AM, Topi Miettinen <toiwoton@gmail.com> wrote:
> > > 
> > > ﻿On 6.4.2020 9.42, Jethro Beekman wrote:
> > >> On 2020-04-04 09:27, Topi Miettinen wrote> Then initramfs should make a similar exception as with v86d and grant exec to /dev.
> > >> I'm not sure this is a reasonable approach. Expect most devices with an Intel processor will have the SGX device going forward. Then, no one is using noexec, so why have this logic at all?
> > > 
> > > Intel does not control the whole market yet, does AMD also offer SGX or similar? Will SGX be also available for consumer devices? Are distros going to enable SGX, will it benefit their users somehow?
> > > 
> > > Perhaps the sgxfs approach or something else (system call?) would be better after all in order to not force exec just because of one device. /dev is usually writable, so allowing exec means breaking the W^X principle for filesystems.
> > > 
> > > 
> > 
> > It’s *possible* to create a tmpfs, create the sgx nodes on it,
> > bind-mount to /dev/sgx/..., and lazy-unmount the tmpfs.
> > 
> > I don’t know whether udev would be willing to support such a thing.
> 
> sgxfs is somewhat trivial to implement and has one stakeholder less to
> worry about. It is not really a huge stretch.
> 
> Overally, I think it is something that we could live with. At least it
> is something that does not step on others toes.
> 
> Haitao: If we go with sgxfs route, then you can for the moment do what
> Andy suggested: bind mount it to /dev/sgx.

I'll head on and write the patch.

Thanks everyone for all the feedback. I don't think this patch set was a
waste of time. It is easier to reflect things when you have the code
rather than pure speculation.

/Jarkko

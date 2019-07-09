Return-Path: <SRS0=ZaoB=VG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B175BC73C46
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 16:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E2062080C
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 16:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfGIQSW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Jul 2019 12:18:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:26366 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfGIQSW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Jul 2019 12:18:22 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 09:18:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,470,1557212400"; 
   d="scan'208";a="364188251"
Received: from mmaitert-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.34.54])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jul 2019 09:18:09 -0700
Date:   Tue, 9 Jul 2019 19:18:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 01/12] x86/sgx: Use mmu_notifier.release() instead
 of per-vma refcounting
Message-ID: <20190709161808.vx6qsnuhzoc4obzk@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-2-sean.j.christopherson@intel.com>
 <20190620210324.GF15383@linux.intel.com>
 <20190708145707.GC20433@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708145707.GC20433@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 08, 2019 at 07:57:07AM -0700, Sean Christopherson wrote:
> On Fri, Jun 21, 2019 at 12:03:36AM +0300, Jarkko Sakkinen wrote:
> > On Wed, Jun 19, 2019 at 03:23:50PM -0700, Sean Christopherson wrote:
> > > Using per-vma refcounting to track mm_structs associated with an enclave
> > > requires hooking .vm_close(), which in turn prevents the mm from merging
> > > vmas (precisely to allow refcounting).
> > 
> > Why having sgx_vma_close() prevents that? I do not understand the
> > problem statement.
> 
> vmas that define .vm_close() cannot be merged.

Ugh, did not know that :-) Thank you.

/Jarkko

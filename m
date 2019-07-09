Return-Path: <SRS0=ZaoB=VG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6414CC73C53
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 16:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4785A216E3
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 16:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfGIQWN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Jul 2019 12:22:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:54281 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfGIQWL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Jul 2019 12:22:11 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 09:22:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,470,1557212400"; 
   d="scan'208";a="364637562"
Received: from mmaitert-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.34.54])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jul 2019 09:22:04 -0700
Date:   Tue, 9 Jul 2019 19:22:03 +0300
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
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
Message-ID: <20190709162203.gzyvulah5u7eksip@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190705160549.tzsck5ho5kvtdhit@linux.intel.com>
 <20190708172930.GA20791@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708172930.GA20791@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 08, 2019 at 10:29:30AM -0700, Sean Christopherson wrote:
> On Fri, Jul 05, 2019 at 07:05:49PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Jun 19, 2019 at 03:23:49PM -0700, Sean Christopherson wrote:
> > 
> > I still don't get why we need this whole mess and do not simply admit
> > that there are two distinct roles:
> > 
> > 1. Creator
> > 2. User
> 
> Because SELinux has existing concepts of EXECMEM and EXECMOD.

What is the official documentation for those? I've only found some
explanations from discussions and some RHEL sysadmin guides.

> That being said, we can do so without functional changes to the SGX uapi,
> e.g. add reserved fields so that the initial uapi can be extended *if* we
> decide to go with the "userspace provides maximal protections" path, and
> use the EPCM permissions as the maximal protections for the initial
> upstreaming.
> 
> That'd give us a minimal implemenation for initial upstreaming and would
> eliminate Cedric's blocking complaint.  The "whole mess" of whitelisting,
> blacklisting and SGX2 support would be deferred until post-upstreaming.

I'd like that approach more too.

/Jarkko

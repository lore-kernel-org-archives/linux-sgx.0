Return-Path: <SRS0=Av94=VC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B50C4649F
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Jul 2019 16:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A4521670
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Jul 2019 16:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfGEQF6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Jul 2019 12:05:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:49722 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfGEQF6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 5 Jul 2019 12:05:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jul 2019 09:05:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,455,1557212400"; 
   d="scan'208";a="363630458"
Received: from hsolima-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.48.252])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jul 2019 09:05:50 -0700
Date:   Fri, 5 Jul 2019 19:05:49 +0300
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
Message-ID: <20190705160549.tzsck5ho5kvtdhit@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619222401.14942-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 03:23:49PM -0700, Sean Christopherson wrote:

I still don't get why we need this whole mess and do not simply admit
that there are two distinct roles:

1. Creator
2. User

In the SELinux context Creator needs FILE__WRITE and FILE__EXECUTE but
User does not. It just gets the fd from the Creator. I'm sure that all
the SGX2 related functionality can be solved somehow in this role
playing game.

An example would be the usual case where enclave is actually a loader
that loads the actual piece of software that one wants to run. Things
simply need to be designed in a way the Creator runs the loader part.
These are non-trivial problems but oddball security model is not going
to make them disappear - on the contrary it will make designing user
space only more complicated.

I think this is classical example of when something overly complicated
is invented in the kernel only to realize that it should be solved in
the user space.

It would not be like the only use case where some kind of privileged
daemon is used for managing some a kernel provided resource.

I think a really good conclusion from this discussion that has taken two
months is to realize that nothing needs to be done in this area (except
*maybe* noexec check).

/Jarkko

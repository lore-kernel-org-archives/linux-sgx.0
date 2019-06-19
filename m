Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111B1C31E49
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 14:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5C09214AF
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 14:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfFSOnX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 10:43:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:26915 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfFSOnX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 10:43:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 07:43:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="335210190"
Received: from stephanf-mobl2.ger.corp.intel.com ([10.252.34.117])
  by orsmga005.jf.intel.com with ESMTP; 19 Jun 2019 07:43:18 -0700
Message-ID: <dc3d59c2783ea81d85d4d447bd1a4a2d5fe51421.camel@linux.intel.com>
Subject: Re: [RFC PATCH v3 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Date:   Wed, 19 Jun 2019 17:43:11 +0300
In-Reply-To: <20190617222438.2080-5-sean.j.christopherson@intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
         <20190617222438.2080-5-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2019-06-17 at 15:24 -0700, Sean Christopherson wrote:
> +	__u32	flags;

This should be changed to secinfo_flags_mask containing a mask of the
allowed bits for the secinfo flags because of two obvious reasons:

1. Protection flags are used mainly with syscalls and contain also other
   things than just the permissions that do not apply in this context.
2. Having a mask for all secinfo flags is more future proof.

With the protection flags you end up reserving bits forever for things
that we will never have any use for (e.g. PROT_SEM).

Looking the change you convert 'flags' (wondering why it isn't called
'prot') to VM flags, which means that you essentially gain absolutely
nothing and loose some potential versatility as a side-effect by doing
that.

/Jarkko


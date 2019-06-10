Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3C9C31E41
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 15:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E338212F5
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 15:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390281AbfFJP12 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 11:27:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:21589 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390177AbfFJP12 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 11:27:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 08:27:28 -0700
X-ExtLoop1: 1
Received: from agusev-mobl.ger.corp.intel.com (HELO localhost) ([10.249.46.248])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jun 2019 08:27:17 -0700
Date:   Mon, 10 Jun 2019 18:27:17 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define enclave
 pages' protection bits
Message-ID: <20190610152717.GB3752@linux.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606021145.12604-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 05, 2019 at 07:11:42PM -0700, Sean Christopherson wrote:
> [SNAP]

Same general criticism as for the previous patch: try to say things as
they are without anything extra.

> A third alternative would be to pull the protection bits from the page's
> SECINFO, i.e. make decisions based on the protections enforced by
> hardware.  However, with SGX2, userspace can extend the hardware-
> enforced protections via ENCLU[EMODPE], e.g. can add a page as RW and
> later convert it to RX.  With SGX2, making a decision based on the
> initial protections would either create a security hole or force SGX to
> dynamically track "dirty" pages (see first alternative above).
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

'flags' should would renamed as 'secinfo_flags_mask' even if the name is
longish. It would use the same values as the SECINFO flags. The field in
struct sgx_encl_page should have the same name. That would express
exactly relation between SECINFO and the new field. I would have never
asked on last iteration why SECINFO is not enough with a better naming.

The same field can be also used to cage page type to a subset of values.

/Jarkko

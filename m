Return-Path: <SRS0=PKbn=UR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34DDAC31E51
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 13:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AF6C2084B
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 13:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFRNz0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Jun 2019 09:55:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:52563 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbfFRNz0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Jun 2019 09:55:26 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 06:55:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,389,1557212400"; 
   d="scan'208";a="334865192"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 18 Jun 2019 06:55:26 -0700
Date:   Tue, 18 Jun 2019 06:55:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v3 00/12] security: x86/sgx: SGX vs. LSM, round 3
Message-ID: <20190618135525.GA13781@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <05bcc1e2-0bd7-dcb9-02c3-969f4484a5fc@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05bcc1e2-0bd7-dcb9-02c3-969f4484a5fc@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 18, 2019 at 09:38:19AM -0400, Stephen Smalley wrote:
> On 6/17/19 6:24 PM, Sean Christopherson wrote:
> >My original plan was for my next RFC to be an implementation of Andy's
> >proposed "dynamic tracking" model.  I actually finished the tracking
> >portion, but was completely flummoxed by the auditing[1].  Since Cedric's
> >RFC is essentially a variation of the dynamic tracking model, it too has
> >the same auditing complexities.  End result, I ended back at the "make
> >userspace state its intentions" approach.
> >
> >Except for patch 12 (see below), the SGX changes have been fully tested,
> >including updating the kernel's selftest as well as my own fork of (an old
> >version of) Intel's SDK to use the new UAPI.  The LSM changes have been
> >smoke tested, but I haven't actually configured AppArmor or SELinux to
> >verify the permissions work as intended.
> 
> Was dropping linux-security-module and selinux lists intentional for this
> RFC? Not recommended.

Yes, my thought was to keep the noise to the sgx list until we at least
agree on a direction for the SGX UAPI.  I am fully expecting that whatever
LSM and SELinux patches we end up with will go through a lot more scrutiny
when Jarkko sends them with his SGX series.

Anyways, would you like me to resend the series to Cc the aforementioned
lists?

> Is the entire series aside from patch 12 available in a public tree
> somewhere?

I pushed tag 'sgx-lsm-v3' to https://github.com/sean-jc/linux.git.

> Ultimately we'll want additions to the selinux-testsuite that exercise each
> of the new permissions, both a permission denied scenario and a permission
> allowed scenario.

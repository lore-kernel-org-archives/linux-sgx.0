Return-Path: <SRS0=hoRE=5Y=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60BBC2D0F4
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Apr 2020 21:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF2BB20771
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Apr 2020 21:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgDHV3i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Apr 2020 17:29:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:51052 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730426AbgDHV3i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 8 Apr 2020 17:29:38 -0400
IronPort-SDR: ECQm23R4tEpbmQO1mJC9UtmvRigonWA7FfTsgG0WCKNVJIXo3TKyVjkAnq81IPcVlLt2TqdfO5
 qIh5aSz+qLTQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2020 14:29:36 -0700
IronPort-SDR: SrCnyy26s0mU/2cv6VLv5pPBzBKxi9WLdNUclSzX0lZ1LnYUetF1kYz9tKiG1lmMV2aZlSH2rJ
 3mHVQrdNuZlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,359,1580803200"; 
   d="scan'208";a="361955390"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 08 Apr 2020 14:29:36 -0700
Date:   Wed, 8 Apr 2020 14:29:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200408212935.GC11322@linux.intel.com>
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
 <ed382297-1488-1cdc-bd3f-a8a45de6c488@gmail.com>
 <20200407165704.GA14583@linux.intel.com>
 <20200407165900.GB14583@linux.intel.com>
 <20200407180410.GA17916@linux.intel.com>
 <7009f0e2-cdfc-1703-2b73-bb683a89c8d1@gmail.com>
 <20200408134049.GB4097@linux.intel.com>
 <64ee4f81-0169-e4f1-9bfb-1b369ee917c4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64ee4f81-0169-e4f1-9bfb-1b369ee917c4@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 09, 2020 at 12:15:36AM +0300, Topi Miettinen wrote:
> On 8.4.2020 16.40, Jarkko Sakkinen wrote:
> >What starts to be obvious is that we don't do anything in code level
> >in SGX particular but instead workaround something around /dev.
> 
> If you take the /dev/sgx path, perhaps you could use KVM as a reference. It
> uses a similar special device /dev/kvm, works well with noexec /dev but
> still it can be used to do much more complex stuff than SGX.

But userspace doesn't need to mmap() /dev/kvm with PROT_EXEC, that's the
rub.  KVM uses anon inodes for VMs, vCPUs, etc..., but doing that on SGX
runs afould of SELinux's PROCESS_EXECMEM, again due to mmap() PROT_EXEC.

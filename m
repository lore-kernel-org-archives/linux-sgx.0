Return-Path: <SRS0=ycpU=5Z=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C69FC2BA19
	for <linux-sgx@archiver.kernel.org>; Thu,  9 Apr 2020 18:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9325206F7
	for <linux-sgx@archiver.kernel.org>; Thu,  9 Apr 2020 18:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgDISjU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 9 Apr 2020 14:39:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:25550 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbgDISjU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 9 Apr 2020 14:39:20 -0400
IronPort-SDR: RAiM7fj7eyUtc5jiY/KlNY5W1Lp4rI/NLZoSbYxuo44mOPP02zqcKblGrWEofq3NSo/IiZYIZ4
 +glt/DuwB7wg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 11:39:20 -0700
IronPort-SDR: qU33k3axnlzWfwMAMiWI2dKHzzYDMLHgdsD3wfP8f/hX4b8liIea1HrUxZN1vTzDKD2jvEWrMm
 S8AjNz4zrp2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,363,1580803200"; 
   d="scan'208";a="362238029"
Received: from abdelh1x-mobl.amr.corp.intel.com (HELO localhost) ([10.249.42.247])
  by fmsmga001.fm.intel.com with ESMTP; 09 Apr 2020 11:39:17 -0700
Date:   Thu, 9 Apr 2020 21:39:16 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200409183904.GA28876@linux.intel.com>
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
 <ed382297-1488-1cdc-bd3f-a8a45de6c488@gmail.com>
 <20200407165704.GA14583@linux.intel.com>
 <20200407165900.GB14583@linux.intel.com>
 <20200407180410.GA17916@linux.intel.com>
 <7009f0e2-cdfc-1703-2b73-bb683a89c8d1@gmail.com>
 <20200408134049.GB4097@linux.intel.com>
 <20200408145636.GD10686@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408145636.GD10686@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 08, 2020 at 07:56:36AM -0700, Sean Christopherson wrote:
> On Wed, Apr 08, 2020 at 04:40:49PM +0300, Jarkko Sakkinen wrote:
> > What starts to be obvious is that we don't do anything in code level
> > in SGX particular but instead workaround something around /dev.
> 
> Can you summarize the plan going forward?  Thanks!

Sure.

The summary is that the permission problem should be solved outside of
SGX. Doing an FS is somewhat big hammer to sort out the permission
problem. It will also make configuration more clunky i.e.  kernel
defines some static permissions and then let say the systemd unit file
will overwrite them with some other. It is somewhat more sound to have
the udev db to contain the permissions.

Admitting that we don't have exact solutions I think we have enough
knowledge to say that things can be refined to work for SGX outside of
SGX.

I've been playing with the idea to add something like SB_I_DEVMMAPEXEC [1]
to superblock flags. This would be set by devtmpfs
(drivers/base/devtmpfs.c) initialization code. Then do_mmap_pgoff should
check this flag from superblock and that we are mapping a device node.
If these premises are fulfilled, then it would allow mmap().

This will make exec work when mapping device nodes but does not allow
attacker to put executable to /dev and run them in the threat scenario
described by Topi [2].

Andy also mentioned that he was going mail to udev ML but have not
checked that at this point.

[1] For explicit control of this new behavior also mnt flag is needed.
[2] https://patchwork.kernel.org/patch/11467637/#23269417

/Jarkko

Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF435C433FE
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 11:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D27723DE3
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 11:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392040AbgLKLjq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Dec 2020 06:39:46 -0500
Received: from kawka.in.waw.pl ([178.62.225.244]:55352 "EHLO kawka.in.waw.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394948AbgLKLjf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Dec 2020 06:39:35 -0500
Received: from zbyszek by kawka.in.waw.pl with local (Exim 4.84_2)
        (envelope-from <zbyszek@in.waw.pl>)
        id 1kngir-0003Yv-B8; Fri, 11 Dec 2020 11:36:29 +0000
Date:   Fri, 11 Dec 2020 11:36:29 +0000
From:   Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Topi Miettinen <toiwoton@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-hotplug@vger.kernel.org,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: Creating executable device nodes in /dev?
Message-ID: <20201211113629.GF7348@in.waw.pl>
References: <f2279f2d-f0a6-a948-9691-96f47a0bd997@gmail.com>
 <308AE66A-F401-4D2D-9D53-17E11EAF68E3@amacapital.net>
 <fd81b46065cd33397e38a17096a206760b7b2937.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd81b46065cd33397e38a17096a206760b7b2937.camel@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 09, 2020 at 10:58:59PM +0100, Ben Hutchings wrote:
> I'm convinced.  I've committed a change to initramfs-tools that removes
> the noexec mount option again.

Systemd counterpart: https://github.com/systemd/systemd/pull/17940.

Zbyszek

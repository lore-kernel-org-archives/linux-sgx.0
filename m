Return-Path: <SRS0=QQlo=5Q=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2301EC43331
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 17:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E10CD2173E
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 17:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585676394;
	bh=mrTfb8zKdALxDBqJzTbXhe9GJEpARsMwIkcK202MZ7w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=zC/8Gvih8vwA85cAc2J+p4Ws9opoZsTE+XRPAuT43Ds/YHmt7bFB8Op2DbRSdPIJ/
	 qWMmbma3AtbcvyI4Hhbja5n45A5QVrrSQVbSfijl6k8vNGRIN1kpmaW2CIWeRyG8zl
	 PBw/+deDQvUzmWiGHOQCZxnYozKCk3oBO72HuuD4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgCaRjx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Mar 2020 13:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgCaRjx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 31 Mar 2020 13:39:53 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDD95214DB
        for <linux-sgx@vger.kernel.org>; Tue, 31 Mar 2020 17:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585676393;
        bh=mrTfb8zKdALxDBqJzTbXhe9GJEpARsMwIkcK202MZ7w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=m7+DpYGOJRcB3r8pBSM4kv/lQY+E9+51ysu4SROmKieNbLBoajdVcf7wjBsJ3S1MO
         f47AfqXPfNA7fqtC0pDBz20NfbBsOmv4woYWLJnYZEXd7YM0sm7qRUviPf/L+39usB
         Whyk3M9mOmaE/mnSq+gQQ3FKzQNO1AfFxtTcQAF0=
Received: by mail-wr1-f46.google.com with SMTP id d5so27201623wrn.2
        for <linux-sgx@vger.kernel.org>; Tue, 31 Mar 2020 10:39:52 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3vCU7vDTpH67OX+I5GMmCPbLjW9sPIxfK3oLsSqbUBqx49fUSx
        mccBmoMycpXVj6kMvmWAjiq3YVEMmZkbntcxqMZtUw==
X-Google-Smtp-Source: ADFU+vtAwdWsHIjEYBbrSEvgKKhyA/XwwninNkefazfP9RP/vpmpFJGVhD1LOE1ODJD538T3WS38KGgWsvppL1jA7nw=
X-Received: by 2002:adf:e901:: with SMTP id f1mr21197584wrm.75.1585676391152;
 Tue, 31 Mar 2020 10:39:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com> <20200331114432.7593-3-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20200331114432.7593-3-jarkko.sakkinen@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 31 Mar 2020 10:39:38 -0700
X-Gmail-Original-Message-ID: <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
Message-ID: <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 31, 2020 at 4:44 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> When creating an enclave attach it to an anonymous file. This prepares the
> code to have a separate interface at runtime, which can be published to the
> user space after the enclave has been fully initialized.

This isn't an objection per se, but I can't shake the feeling that
this seems ridiculous.  This changes the type of object returned by
open() because, without this change, the old type was problematic.

So I have some questions:

 - Can sgx just ignore the fs noexec option on the chardev inode's fs instead?

 - Would SELinux users *want* to put a useful label on the inode?  if
so, can they still accomplish whatever they were trying to accomplish
with this patch applied?

--Andy

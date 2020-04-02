Return-Path: <SRS0=/ylb=5S=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F2EC43331
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Apr 2020 21:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C87520719
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Apr 2020 21:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585863715;
	bh=UtVQyQczFD3r2xzxuT0UZV15V3pi+sE4Ot5qpurpCIY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=awwjL2HO0/AIUCZEuL5nI07wPj/AdqpSFzPJeBt7D7NYp5XKcrDlq/WdDFMtIasp4
	 LQar5iMpsJpnZ13gpxjJyc8pFWYBlv+/M/DuzE3N0u2BDCIT/HefzYz/CUNIiZXz/g
	 F/U1TT21lkKpyXAo1TN0FpefkuzBfd89qV4aPT0s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbgDBVlz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Apr 2020 17:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgDBVlz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Apr 2020 17:41:55 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F694208E0
        for <linux-sgx@vger.kernel.org>; Thu,  2 Apr 2020 21:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585863714;
        bh=UtVQyQczFD3r2xzxuT0UZV15V3pi+sE4Ot5qpurpCIY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eYygjZSRdqQW9pUY0Af7FSF0nzPbH4hpEK/dMHSe1DEcjJAYpmOIL4Ei9DWTapiFR
         heY8M2zKo8GZuNW4+MnBNQt9RfiMVveRSz5sbSyAwZNGo/aPp9AHYV4U6yJp/lirea
         4B0aSvwEcnfaq+vvuPP7jNy9B8IsatGoYxknk19Q=
Received: by mail-wr1-f52.google.com with SMTP id m17so5990543wrw.11
        for <linux-sgx@vger.kernel.org>; Thu, 02 Apr 2020 14:41:54 -0700 (PDT)
X-Gm-Message-State: AGi0PuZfdpdkrGc6ChO/zzN89HCcRjeeVB9AqqPmTPowCP+7c6ozKbA4
        TAyiDDsELTZu/6t6BQDBh2sgfJfHFtSP0eOSEvQGYg==
X-Google-Smtp-Source: APiQypJyomJDKXHEtNVSBfXOFR75rG8KqVY6UNKhc29vBn+Woud0jzbO8OQmZWgmTZtEG7PGSW8Hftagzt1g6JVXsrg=
X-Received: by 2002:adf:dd05:: with SMTP id a5mr5579004wrm.18.1585863712727;
 Thu, 02 Apr 2020 14:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
 <20200331114432.7593-3-jarkko.sakkinen@linux.intel.com> <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
 <20200401002443.GE4847@linux.intel.com>
In-Reply-To: <20200401002443.GE4847@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 2 Apr 2020 14:41:39 -0700
X-Gmail-Original-Message-ID: <CALCETrW8pLFRAnQdpxuBG-CDuUN5B8T-FqN5TvAVD--ZR=78-Q@mail.gmail.com>
Message-ID: <CALCETrW8pLFRAnQdpxuBG-CDuUN5B8T-FqN5TvAVD--ZR=78-Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 31, 2020 at 5:24 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Mar 31, 2020 at 10:39:38AM -0700, Andy Lutomirski wrote:
>
> If EXECMEM is a sticking point, one way to dodge it would be to add a
> helper to allow SELinux to detect enclave files.  It'd be ugly, but simple.
> That doesn't solve the generic labeling issue though.  It also begs the
> question of why hacking SELinux but not do_mmap() would be acceptable.
>
> If you have any ideas for fixing the noexec issue without resorting to an
> anon inode, we're all ears.

Hmm.  Maybe teach udev to put /dev/sgx on a different fs and
bind-mount it?  Or make /dev/sgx be an actual filesystem?  Or just
mount /dev with exec enabled?

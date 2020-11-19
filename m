Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8FA4C6369E
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 16:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EA05246CA
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 16:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1AoTqe9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgKSQR0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:17:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbgKSQRZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Nov 2020 11:17:25 -0500
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D89ED246AD
        for <linux-sgx@vger.kernel.org>; Thu, 19 Nov 2020 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605802645;
        bh=F5yOB0sHtQnLJ+NSs4Zd8ZtoTYl7kru0uDQUP+184TY=;
        h=From:Date:Subject:To:From;
        b=a1AoTqe9vplo1OWoTpbEHtBpGp7NOkHonrThzEJS5p/jU1zJTz9Su9vTKNaV7CmfH
         kXmJkJxbWzhA9Rbc1bePpuhzSeUIy2HgAsZLeXOvrEzGUd3Hjyqwdz5fdz2Sewk/f2
         /S97G8sJR8DaUghkFN47JMhmXL8frK1zQt8tcHW4=
Received: by mail-wm1-f50.google.com with SMTP id a186so4939264wme.1
        for <linux-sgx@vger.kernel.org>; Thu, 19 Nov 2020 08:17:24 -0800 (PST)
X-Gm-Message-State: AOAM5315nns6FrjaHZJPOm2ub66I1cJpnRtwtezqt2+aVK9Y8ZAredha
        wlixOJtKWoiWr6Z1UQh+oL/pv/Fuh7FaGiA8Uw8zVw==
X-Google-Smtp-Source: ABdhPJwSngghiuPwizDjdQ4dcFBHvtxi8VSnf5s5+0FSAlFkN04RleHetq0bZUbm15M2sFTqbziKyO+BEgzBvuxpn14=
X-Received: by 2002:a1c:7e87:: with SMTP id z129mr5313951wmc.176.1605802643292;
 Thu, 19 Nov 2020 08:17:23 -0800 (PST)
MIME-Version: 1.0
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 19 Nov 2020 08:17:08 -0800
X-Gmail-Original-Message-ID: <CALCETrWM2rGPRudtaQ=mn9MRsrbQqFfZDkOGsBbVMsk6mMw_+A@mail.gmail.com>
Message-ID: <CALCETrWM2rGPRudtaQ=mn9MRsrbQqFfZDkOGsBbVMsk6mMw_+A@mail.gmail.com>
Subject: Creating executable device nodes in /dev?
To:     linux-hotplug@vger.kernel.org,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Topi Miettinen <toiwoton@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi udev people-

The upcoming Linux SGX driver has a device node /dev/sgx.  User code
opens it, does various setup things, mmaps it, and needs to be able to
create PROT_EXEC mappings.  This gets quite awkward if /dev is mounted
noexec.

Can udev arrange to make a device node executable on distros that make
/dev noexec?  This could be done by bind-mounting from an exec tmpfs.
Alternatively, the kernel could probably learn to ignore noexec on
/dev/sgx, but that seems a little bit evil.

Thanks,
Andy

Return-Path: <SRS0=WPzH=U4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A2DC5B57A
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Jun 2019 01:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADEB22086D
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Jun 2019 01:16:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DVETekdA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfF2BQM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jun 2019 21:16:12 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35487 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfF2BQL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 28 Jun 2019 21:16:11 -0400
Received: by mail-io1-f66.google.com with SMTP id m24so16385042ioo.2;
        Fri, 28 Jun 2019 18:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qRwEW4To+9Vet9WyMly39lecgpipf9b/EueO2sYjm1w=;
        b=DVETekdASMfs54APu7zxBq6Si1VkIFmkWK+gEf9ZWHs2sxE9SH640E2MLy7macJjbD
         DadtE4nlwk95jh0rJf496K8YsoQsPr+nGrEGeoO3NobdiG198KkWiq2Rd1/j1YyG39nS
         tttL6oJox9A+PcYmz3pXplZekTb6j50UAFnB+P0UCHp5YisJ+KmqCJ3+8xqqLP9G+XWc
         oUPsKgLf0clSs9W4929IxEBQcrBJejwUgu9KEcnHX2zyILDpVKotZjxdAosIANxEeCTV
         FMlW/q5jfrkwQGhN4m4qRlqpDDMGwu3Wm/heHIfgcgI0NP5maAcX7MVGDl3yR5rNwWbF
         006A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qRwEW4To+9Vet9WyMly39lecgpipf9b/EueO2sYjm1w=;
        b=DDGmYj+1DxTZZRmE0kMzJxNSPUVgXWp1KxQ4djwFt1abRxE54zl3zOuYTXkCvjmU9+
         58z23qgSDaZZ66Yi06dRUGkeZPId3sQ9DFQcEXaMageA04S2zBw9ai2iDOxDGh5sML0Z
         0ZWD6SjrolHnJ5FBPYgPhbNt/XblkPXTfekrczoFY4gzpKWam7lkOl+tisw9jDbugk5F
         H/4HHpiU7HYRu0zE+vKEYSyemKW6O0Ls4tRSHLnQga2KJRhUVSJI0wLPdBak5F32N4LF
         c0HXDINLGI36e4m1YD0CvWy/AOQdIeuLs6cGPlpFQWUt+q3/ICTZYLEfeqdccx0Rp8m0
         y5xA==
X-Gm-Message-State: APjAAAUwc7f3UOotwFElLWkcCw1XZ90FCiB9ssXvmsDR6hTXdLY7f67k
        eHsqce4oUgNjEGJ3rwue/YIi4lCmIt9+XzEqTvc=
X-Google-Smtp-Source: APXvYqxR0UvmySPdpUIVdaiAuxcEHnu2QQTNWDyMMm2p6X9bFwKh22s+2y3+9nlVch+Z3kMtgFfsAVdW5GWIcsLNXcQ=
X-Received: by 2002:a5d:9d97:: with SMTP id 23mr14593214ion.204.1561770969818;
 Fri, 28 Jun 2019 18:16:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com> <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
 <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov> <960B34DE67B9E140824F1DCDEC400C0F6551B824@ORSMSX116.amr.corp.intel.com>
 <99499d1a-56eb-60b0-596c-6d24e38d4757@tycho.nsa.gov> <960B34DE67B9E140824F1DCDEC400C0F6551C422@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551C422@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <stephen.smalley@gmail.com>
Date:   Fri, 28 Jun 2019 21:15:57 -0400
Message-ID: <CAB9W1A1D=uDEdfSjS9DDNbThA1_HwATJN3=BcxZdXX5qMGHFrA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 10/12] security/selinux: Add enclave_load() implementation
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 28, 2019 at 5:20 PM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> > From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
> > owner@vger.kernel.org] On Behalf Of Stephen Smalley
> > Sent: Friday, June 28, 2019 9:17 AM
> >
> > FWIW, adding new permissions only requires updating policy configuratio=
n,
> > not userspace code/tools.  But in any event, we can reuse the execute-
> > related permissions if it makes sense but still consider introducing
> > additional, new permissions, possibly in a separate "enclave" security
> > class, if we want explicit control over enclave loading, e.g.
> > ENCLAVE__LOAD, ENCLAVE__INIT, etc.
>
> I'm not so familiar with SELinux tools so my apology in advance if I end =
up mixing up things.
>
> I'm not only talking about the new permissions, but also how to apply the=
m to enclave files. Intel SGX SDK packages enclaves as .so files, and I gue=
ss that's the most straight forward way that most others would do. So if di=
fferent permissions are defined, then user mode tools would have to disting=
uish enclaves from regular .so files in order to grant them different permi=
ssions. Would that be something extra to existing tools?

It doesn't require any userspace code changes.  It is just a matter of
defining some configuration data in the policy for the new
permissions, one or more security labels (tags) for the SGX .so files,
and rules allowing access where desired, and then setting those
security labels on the SGX .so files (via the security.selinux
extended attribute on the files).  Even the last part is generally
handled by updating a configuration specifying how files should be
labeled and then rpm automatically labels the files when created, or
you can manually restorecon them. If the new permissions are defined
in their own security class rather than reusing existing ones, then
they can even be defined entirely via a local or third party policy
module separate from the distro policy if desired/needed.

>
> >
> > One residual concern I have with the reuse of FILE__EXECUTE is using it
> > for the sigstruct file as the fallback case.  If the sigstruct is alway=
s
> > part of the same file as the code, then it probably doesn't matter.  Bu=
t
> > otherwise, it is somewhat odd to have to allow the host process to
> > execute from the sigstruct file if it is only data (the signature).
>
> I agree with you. But do you think it a practical problem today? As far a=
s I know, no one is deploying sigstructs in dedicated files. I'm just tryin=
g to touch as few things as possible until there's definitely a need to do =
so.

I don't know, and it wasn't clear to me from the earlier discussions.
If not and if it is acceptable to require them to be in files in the
first place, then perhaps it isn't necessary.
